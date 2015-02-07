FactoryGirl.define do
  factory :match do
    association :home_player, factory: :player
    association :away_player, factory: :player

    transient do
      home_score 5
      away_score 6
    end

    after(:create) do |match, evaluator|
      create_list :point, evaluator.away_score, victor: match.away_player, match: match
      create_list :point, evaluator.home_score, victor: match.home_player, match: match
    end

    trait :finalized do
      sequence(:finalized_at) { |n| n.minutes.ago }
    end

    trait :finished do
      transient do
        home_score 11
      end
    end

    trait :at_start do
      transient do
        home_score 0
        away_score 0
      end
    end
  end
end
