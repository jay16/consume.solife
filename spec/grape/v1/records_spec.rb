require 'spec_helper'

describe Consume::API::V1::Records do
  let(:user) do 
    !(user = User.first).nil? ?  user : FactoryGirl.create(:user) 
  end

  describe "GET /api/v1/records" do
    (0..20).each do |i|
      let("record#{i}".to_sym)  { FactoryGirl.create(:record, :user => user) }
    end

    it "should get a record with id" do
      get "/api/v1/records/#{record10.id}.json", { token: user.token }

      expect(response.status).to eq(200)

      json = jparse(response.body)
      j_user = User.find(json["user_id"])
      expect(j_user).to eq(user)
      j_record = j_user.records.find(json["id"])
      expect(j_record).to eq(record10)
    end

    it "should get records list" do
      get "/api/v1/records.json", { token: user.token }

      expect(response.status).to eq(200)
      expect(jparse(response.body)).to eq(user.records)
    end

    it "should get records list with ID" do
      get "/api/v1/records.json", { token: user.token, id: record10.id }

      expect(response.status).to eq(200)
      expect(jparse(response.body)).to eq(user.records.where("id > #{record10.id}"))
    end
    
    it "get records list with UpdatedAt" do
      record11.update(value: record11.value + rand(100))
      updated_at = record11.updated_at.strftime('%Y-%m-%d %H:%i:%s') 
      get "/api/v1/records.join", { token: user.token, updated_at: updated_at }

      expect(response.status).to eq(200)
      expect(jparse(response.body)).to eq(user.records.where("updated_at > '#{updated_at}'"))
    end

  end

  describe "Get /api/v1/records/friends" do
    it "get friends' records list" do
      #get "/api/records/friends.json", { token: user.token }

      #expect(response.status).to eq(200)
      #expect(jparse(response.body)).to eq([])
    end
  end

  describe "POST /api/v1/records" do
    let(:valid_params_symbol) {
      { 
        value: rand(1000).to_f,
        ymdhms: Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        remark: ["remark", rand(1000), Time.now.strftime("%Y-%m-%d %H:%M:%S")].join(" - "),
        klass: rand(5),
        tags_list: ["tag#{rand(1000)}", "tag#{rand(1000)}"].join(",")
      }
    }
    let(:valid_params_string) {
      { 
        "value" => rand(1000).to_f,
        "ymdhms" => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
        "remark" => ["remark", rand(1000), Time.now.strftime("%Y-%m-%d %H:%M:%S")].join(" - "),
        "klass" => rand(5),
        "tags_list" => ["tag#{rand(1000)}", "tag#{rand(1000)}"].join(",")
      }
    }

    it "should create Record with symbol valid params" do
      post "/api/v1/records.json", { token: user.token, record: valid_params_symbol }
      # httpcode 201 => created successfully
      expect(response.status).to eq(201)

      json = jparse(response.body)
      j_user = User.find(json["user_id"])
      expect(j_user).to eq(user)
      expect(json["deleted"]).to eq(false)

      j_klass = json["klass"]
      j_tags_list = json["tags_list"]
      j_tags_list.split(",").each do |label|
        # post tags_list will create or find tag
        tag = Tag.where(klass: j_klass, label: label).first
        expect(tag.valid?).to eq(true)
      end
    end

    it "should create Record with string valid params" do
      post "/api/v1/records.json", { "token" => user.token, "record" => valid_params_symbol }
      # httpcode 201 => created successfully
      expect(response.status).to eq(201)

      json = jparse(response.body)
      j_user = User.find(json["user_id"])
      expect(j_user).to eq(user)
      expect(json["deleted"]).to eq(false)

      j_klass = json["klass"]
      j_tags_list = json["tags_list"]
      j_tags_list.split(",").each do |label|
        # post tags_list will create or find tag
        tag = Tag.where(klass: j_klass, label: label).first
        expect(tag.valid?).to eq(true)
      end
    end

    let(:record)  { FactoryGirl.create(:record, :user => user) }
    it "should update a Record with id" do
      valid_params_symbol[:value] = record.value + rand(1000)
      post "/api/v1/records/#{record.id}.json", { token: user.token, record: valid_params_symbol }
      expect(response.status).to eq(201)

      json = jparse(response.body)
      expect(json["id"]).to eq(record.id)
      expect(json["deleted"]).to eq(false)
    end
  end

  describe "Delete /api/v1/records" do
    let(:record)  { FactoryGirl.create(:record, :user => user) }

    it "should destroy a record with id" do
      delete "/api/v1/records/#{record.id}.json", { token: user.token }

      expect(response.status).to eq(200)
      json = jparse(response.body)
      expect(json["id"]).to eq(record.id)
      expect(json["deleted"]).to eq(true)
    end
  end
end

