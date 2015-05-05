#encoding: utf-8
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

    it "should return user report" do
      get "/api/v1/users/user_report.json", { token: user.token }

      expect(response.status).to eq(200)
      expect(jparse(response.body).keys.map(&:to_s)).to eq(APIEntities::UserReport.exposures.keys.map(&:to_s))
    end

    it "should return group member report with report type as text" do
      get "/api/v1/users/group_member_report.json", { token: user.token, report_type: "text" }

      expect(response.status).to eq(200)
      expect(jparse(response.body)["report"].class).to eq(String)
    end
    it "should return group member report with report type as text" do
      get "/api/v1/users/group_member_report.json", { token: user.token, report_type: "json" }

      expect(response.status).to eq(200)
      expect(jparse(response.body)["report"].class).to eq(Hash)
      expect(jparse(response.body)["report"].keys.map(&:to_s)).to eq(%w(member count value))
    end
  end
end

