FactoryGirl.define do
  factory :experience do
    player
    association(:match, factory: :complete_match)
    reason :completed_match
  end
end
