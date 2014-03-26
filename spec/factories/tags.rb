FactoryGirl.define do
  factory :tag do
    user
    sequence(:label) { |n| "tag#{n}" }
  end
end
