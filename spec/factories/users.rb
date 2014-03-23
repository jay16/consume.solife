FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@solife.us" }
    password "helloworld"
    password_confirmation "helloworld"
  end
end
