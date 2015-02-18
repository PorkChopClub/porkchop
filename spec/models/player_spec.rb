require 'rails_helper'

RSpec.describe Player, type: :model do
  it { is_expected.to have_many :points }
  it { is_expected.to have_many :victories }

  it "is invalid without a name" do
    expect(described_class.new.valid?).to be false
  end

  it "is valid with a name" do
    expect(described_class.new(name: 'Jeff').valid?).to be true
  end

  describe "#matches" do
    subject { player.matches }

    let!(:away_match) { FactoryGirl.create :match, away_player: player }
    let!(:home_match) { FactoryGirl.create :match, home_player: player }
    let(:player) { FactoryGirl.create :player }

    it "includes both home and away matches" do
      expect(subject).to match_array [home_match, away_match]
    end
  end

  describe "#losses" do
    subject { player.losses }

    let!(:win) { FactoryGirl.create :complete_match, away_player: player, victor: player }
    let!(:loss) { FactoryGirl.create :complete_match, away_player: player }
    let!(:incomplete_match) { FactoryGirl.create :match, home_player: player }
    let(:player) { FactoryGirl.create :player }

    specify { expect(subject).to match_array [loss] }
  end
end
