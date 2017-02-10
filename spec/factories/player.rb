require 'ffaker'

FactoryGirl.define do
  factory :player do
    sequence(:email) { |n| "cbergen#{n}@example.com" }
    password "password"
    name { FFaker::Name.name }
    legacy_avatar_url do
      width = rand(40..1000)
      height = rand(40..1000)
      "https://www.placecage.com/#{width}/#{height}"
    end

    trait :confirmed do
      confirmed_at { 1.hour.ago }
    end

    trait :active do
      active true
    end

    factory :active_player, traits: [:active]

    factory :admin_player, traits: [:confirmed] do
      admin true
    end
  end
end
