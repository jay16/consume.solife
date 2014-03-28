#encoding: utf-8
require 'spec_helper'

describe HomeController do
  before :each do 
    @user = create(:user)
  end
  #let(:user) { Factory :user }

  describe "GET 'index'" do
    it "should show register link if user not signed in" do
      visit "/"
      get :index
      response.should_not be_success
      page.should have_content("登陆")
    end

    it "should show index if user is signed in" do
      visit "/"
      sign_in @user
      
      get :index
      response.should be_success
      #expect(page).to have_content("Home")
    end
  end

end
