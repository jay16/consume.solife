require 'spec_helper'

describe Consume::API do
  #let(:user) { FactoryGirl.create(:user) }
  #let(:my_params) { { format: "json", token: user.token } }

  describe "users" do
    it "should return current_user info when GET" do
      get "/api/users.json"
      expect(response).to be("dd")
    end
  end
end
