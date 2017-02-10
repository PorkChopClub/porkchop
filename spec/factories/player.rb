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

    trait :active do
      active true
    end

    factory :active_player, traits: [:active]

    factory :admin_player do
      admin true
    end
  end
end
