FactoryGirl.define do
  factory :player do
    sequence(:email) { |n| "cbergen#{n}@example.com" }
    password "password"
    sequence(:name) { |n| "Candice Bergen ##{n}" }
    avatar_url "http://bit.ly/15E65sT"
  end
end
