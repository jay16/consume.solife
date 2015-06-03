require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    let(:user) { FactoryGirl.create(:user) }
    it "blocks unauthenticated access" do
      visit "/users/sign_in"
      sign_in nil

      get :index
      expect(response).to redirect_to(new_user_session_path)
    end


   it "allows authenticated access" do
      visit "/users/sign_in"
      sign_in user

      get :index

      response.should be_success
      expect(response.body).to have_content(user.name)
    end
  end

end
