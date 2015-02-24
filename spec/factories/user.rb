FactoryGirl.define do
  factory :user do
    username "candicebergenfan"
    uid "1234567890"
    provider "twitter"

    factory :admin_user do
      admin true
    end
  end
end
