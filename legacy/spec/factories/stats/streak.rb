FactoryGirl.define do
  factory :streak, class: Stats::Streak do
    association :player
    streak_length 1
    streak_type "W"

    trait :finished do
      finished_at 1.day.ago
    end
  end
end
