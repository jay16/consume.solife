#encoding: utf-8
require 'spec_helper'

describe HomeController do
  describe "GET 'home#index'" do
    let(:user) { FactoryGirl.create(:user) }

    it "should show register link when user not signed in" do
      get :index

      response.should be_success
      expect(page).to have_content("登陆")
    end

    it "should response normally as third api" do
      timestamp = Time.now.to_s
      get "solife_get", { echostr: timestamp }
      expect(response.body).to eq(timestamp)
    end
  end

end
