FactoryGirl.define do
  factory :match do
    association :home_player, factory: :player
    association :away_player, factory: :player
    first_service :first_service_by_home_player

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

      after(:build) do |match|
        match.victor ||= match.home_player
      end
    end

    trait :finished do
      transient do
        home_score 11
      end
    end

    trait :at_start do
      first_service nil
      transient do
        home_score 0
        away_score 0
      end
    end

    trait :first_service_by_home_player do
      first_service :first_service_by_home_player
    end

    trait :first_service_by_away_player do
      first_service :first_service_by_away_player
    end


    factory :complete_match, traits: [:finalized, :finished]
    factory :new_match, traits: [:at_start]
  end
end
