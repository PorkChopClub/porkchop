FactoryGirl.define do
  factory :player do
    sequence(:email) { |n| "cbergen#{n}@example.com" }
    password "password"
    sequence(:name) { |n| "Candice Bergen ##{n}" }
    legacy_avatar_url "http://bit.ly/15E65sT"

    trait :confirmed do
      confirmed_at { 1.hour.ago }
    end

    factory :admin_player, traits: [:confirmed] do
      sequence(:email) { |n| "cbergen#{n}@stembolt.com" }
    end
  end
end
