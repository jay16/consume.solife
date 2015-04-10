require 'spec_helper'

describe Consume::API do
  let(:user) do 
    !(user = User.first).nil? ?  user : FactoryGirl.create(:user) 
  end

  describe "GET /api/v1/users" do
    it "should return error without user's token" do
      get "/api/v1/users.json"

      expect(response.status).to eq(401)
      expect(jparse(response.body)["error"]).to eq("401 Unauthorized")
    end

    it "should return current_user's info" do
      get "/api/v1/users.json", { token: user.token }

      expect(response.status).to eq(200)
      expect(jparse(response.body)["id"]).to eq(user.id)
    end
  end
end

