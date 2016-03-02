require 'rails_helper'

RSpec.describe BettingInfo, type: :model do
  it { is_expected.to belong_to :match }
  it { is_expected.to validate_presence_of :match }

  describe ".create" do
    subject { described_class.create(match: match) }

    let(:match) { FactoryGirl.create :match }
    let(:spread_double) { instance_double Betting::Spread }

    it "calculates the favourite/spread" do
      expect(Betting::Spread).
        to receive(:new).
        and_return(spread_double)
      expect(spread_double).
        to receive(:spread).
        and_return(2.5)
      expect(spread_double).
        to receive(:favourite).
        and_return(match.home_player)
      expect(subject.spread).to eq 2.5
      expect(subject.favourite).to eq match.home_player
    end
  end
end
