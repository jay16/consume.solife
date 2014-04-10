#encoding: utf-8
require 'spec_helper'

describe HomeController do
  describe "GET 'home#index'" do
    let(:user) { FactoryGirl.create(:user) }

    it "should show register link if user not signed in" do
      visit "/"
      get :index

      response.should_not be_success
      expect(page).to have_content("登陆")
    end

    it "should show index if user has signed in" do
      visit "/"
      sign_in user
      
      get :index
      expect(page).to have_content(user.name)
      response.should be_success
    end
  end

end
