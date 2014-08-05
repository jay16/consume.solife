require 'spec_helper'

describe Consume::API do
  let(:user) do 
    !(user = User.first).nil? ?  user : FactoryGirl.create(:user) 
  end

  describe "GET /api/version" do
    it "should return error without os" do
      get "/api/version.json"

      expect(response.status).to eq(404)
      expect(jparse(response.body)["error"].strip).to eq("should in [android]")
    end
    it "should return error with ios" do
      get "/api/version.json", { os: "ios" }

      expect(response.status).to eq(404)
      expect(jparse(response.body)["error"].strip).to eq("ios should in [android]")
    end
    it "should should lastest mobile client info" do
      get "/api/version.json", { os: "android" }

      expect(response.status).to eq(200)
      json = jparse(response.body)
      expect(json["version"]).to eq(Setting.mobile.os.android.version)
      expect(json["apk_name"]).to eq(File.basename(Setting.mobile.os.android.url))
      expect(json["describtion"]).to eq(Setting.mobile.os.android.describtion)
      expect(json["url"]).to eq(Setting.mobile.os.android.url)
    end
  end
end

