require "rails_helper"

RSpec.describe League, type: :model do
  it { is_expected.to have_many :seasons }

  it "is invalid without a name" do
    expect(described_class.new.valid?).to be false
  end
end
