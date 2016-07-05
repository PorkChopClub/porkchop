FactoryGirl.define do
  factory :table do
    sequence(:name) { |n| "Table ##{n}" }

    factory :default_table do
      name Table::DEFAULT_TABLE_NAME
    end
  end
end
