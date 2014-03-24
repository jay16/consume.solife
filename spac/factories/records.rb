# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :record do
    user_id 1
    value 1.5
    remark "MyText"
    ymdhms "MyString"
  end
end
