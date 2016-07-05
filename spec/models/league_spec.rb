require "rails_helper"

RSpec.describe League, type: :model do
  it { is_expected.to have_many :seasons }
  it { is_expected.to belong_to :table }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :table }

  it "is invalid without a name" do
    expect(described_class.new.valid?).to be false
  end
end
