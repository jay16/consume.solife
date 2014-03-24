# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    user_id 1
    label "MyString"
  end
end
