FactoryGirl.define do
  factory :player do
    # http://bit.ly/15E65sT
    sequence(:name) { |n| "Candice Bergen ##{n}" }
  end
end
