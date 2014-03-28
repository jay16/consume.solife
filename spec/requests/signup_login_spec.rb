#encoding: utf-8
require "spec_helper"

describe "sign up and login" do
  it "blocks unauthenticated access" do
    sign_in nil

    get :index

    response.should redirect_to(new_user_session_path)
  end

  it "allows authenticated access" do
    sign_in

    get :index

    response.should be_success
  end
  
  it "let user sign up and login" do
    visit "/"
    click_link "注册"
    fill_in "邮箱", with: "email@solife.us"
    fill_in "密码", with: "123456"
#    fill_in "确认密码", with: "1234567"
    click_button "提交"

    page.should have_content("Home")
  end
end
