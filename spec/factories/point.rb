FactoryGirl.define do
  factory :point do
    match
    association :victor, factory: :player
  end
end
