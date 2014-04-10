#encoding: utf-8
require "spec_helper"

describe "sign up and login" do
  it "sign out" do
    visit "/"
    click_link "注册"
    fill_in "邮箱", with: "email@solife.us"
    fill_in "密码", with: "123456", match: :prefer_exact
    fill_in "确认密码", with: "1234567", match: :prefer_exact
    click_button "提交"

    expect(response.body).to have_content("email@solife.us")
  end
end
