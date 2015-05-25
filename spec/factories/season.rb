FactoryGirl.define do
  factory :season do
    games_per_matchup 1

    trait :finalized do
      sequence(:finalized_at) { |n| n.minutes.ago }
    end
  end
end
