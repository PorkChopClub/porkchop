require 'rails_helper'

RSpec.describe Player, type: :model do
  it { is_expected.to have_many :points }

  it "is invalid without a name" do
    expect(described_class.new.valid?).to be false
  end

  it "is valid with a name" do
    expect(described_class.new(name: 'Jeff').valid?).to be true
  end
end
