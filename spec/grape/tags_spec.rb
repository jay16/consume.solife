require 'spec_helper'

describe Consume::API do
  let(:user) { FactoryGirl.create(:user) }
  let(:timestamp) { Time.now.strftime("%Y-%m-%d %H:%M:%S") }

  describe "GET /api/tags" do
    (0..20).each do |i|
      let("tag#{i}".to_sym)  { FactoryGirl.create(:tag, :user => user) }
    end

    it "should get a tag with id" do
      get "/api/tags/#{tag10.id}.json", { token: user.token }

      expect(response.status).to eq(200)

      json = jparse(response.body)
      j_user = User.find(json["user_id"])
      expect(j_user).to eq(user)
      j_tag = j_user.tags.find(json["id"])
      expect(j_tag).to eq(tag10)
    end

    it "should get tags list" do
      get "/api/tags.json", { token: user.token }

      expect(response.status).to eq(200)
      expect(jparse(response.body)).to eq(user.tags)
    end

    it "should get tags list with ID" do
      get "/api/tags.json", { token: user.token, id: tag10.id }

      expect(response.status).to eq(200)
      expect(jparse(response.body)).to eq(user.tags.where("id > #{tag10.id}"))
    end
    
    it "get tags list with UpdatedAt" do
      tag11.update(label: tag11.label + rand(100).to_s)
      updated_at = tag11.updated_at.strftime('%Y-%m-%d %H:%i:%s') 
      get "/api/tags.join", { token: user.token, updated_at: updated_at }

      expect(response.status).to eq(200)
      expect(jparse(response.body)).to eq(user.tags.where("updated_at > '#{updated_at}'"))
    end

  end

  describe "Get /api/tags/friends" do
    it "get friends' tags list" do
      get "/api/tags/friends.json", { token: user.token }

      #expect(response.status).to eq(200)
      #expect(jparse(response.body)).to eq([])
    end
  end

  describe "POST /api/tags" do
    let(:valid_params_symbol) {
      { 
        label: ["tag", rand(300)].join("-"),
        klass: rand(5),
      }
    }
    let(:valid_params_string) {
      { 
        "label" => ["tag", rand(300)].join("-"),
        "klass" => rand(5),
      }
    }

    it "should create tag with symbol valid params" do
      post "/api/tags.json", { token: user.token, tag: valid_params_symbol }
      # httpcode 201 => created successfully
      expect(response.status).to eq(201)

      json = jparse(response.body)

      expect(json["deleted"]).to eq(false)
      j_user = User.find(json["user_id"])
      expect(j_user).to eq(user)

      j_tag   = user.tags.find(json["id"])
      expect(j_tag.klass).to eq(json["klass"])
    end

    it "should create tag with string valid params" do
      post "/api/tags.json", { "token" => user.token, "tag" => valid_params_symbol }
      # httpcode 201 => created successfully
      expect(response.status).to eq(201)

      json = jparse(response.body)

      expect(json["deleted"]).to eq(false)
      j_user = User.find(json["user_id"])
      expect(j_user).to eq(user)

      j_tag   = user.tags.find(json["id"])
      expect(j_tag.klass).to eq(json["klass"])
    end

    let(:tag)  { FactoryGirl.create(:tag, :user => user) }
    it "should update a tag with id" do
      valid_params_symbol[:label] += rand(1000).to_s
      post "/api/tags/#{tag.id}.json", { token: user.token, tag: valid_params_symbol }
      expect(response.status).to eq(201)

      json = jparse(response.body)
      expect(json["id"]).to eq(tag.id)
      expect(json["deleted"]).to eq(false)
    end
  end

  describe "Delete /api/tags" do
    let(:tag)  { FactoryGirl.create(:tag, :user => user) }

    it "should destroy a tag with id" do
      delete "/api/tags/#{tag.id}.json", { token: user.token }

      expect(response.status).to eq(200)
      json = jparse(response.body)
      expect(json["id"]).to eq(tag.id)
      expect(json["deleted"]).to eq(true)
    end
  end
end

