FactoryGirl.define do
  factory :record do
    user
    sequence(:value) { |n| (rand(1000)/n) }
    sequence(:remark) { |n| "consume with #{n}" }
    ymdhms { Time.now.strftime("%Y-%m-%d %H:%M:%S") }
    tags_list { "one,two" }
  end
end
