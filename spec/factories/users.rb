FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "name#{n}" }
    sequence(:email) { |n| "email#{n}@solife.us" }
    password "helloworld"
    password_confirmation "helloworld"
  end
end
