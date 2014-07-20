require 'spec_helper'

describe Consume::API do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET /api/users" do
    it "should should return current_user's info" do
      get "/api/users.json", { token: user.token }

      expect(response.status).to eq(200)
      expect(jparse(response.body)["id"]).to eq(user.id)
    end
  end
end

