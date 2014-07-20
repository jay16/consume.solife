require 'spec_helper'

describe Consume::API do
  let(:user) { FactoryGirl.create(:user) }

  describe "GET /api/version" do
    it "should should lastest mobile client info" do
      get "/api/version.json", { token: user.token, os: "android" }

      expect(response.status).to eq(200)
      json = jparse(response.body)
      expect(json["version"]).to eq(Setting.mobile.os.android.version)
      expect(json["apk_name"]).to eq(File.basename(Setting.mobile.os.android.url))
      expect(json["describtion"]).to eq(Setting.mobile.os.android.describtion)
      expect(json["url"]).to eq(Setting.mobile.os.android.url)
    end
  end
end

