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

    let!(:away_match) do
      FactoryGirl.create :match,
        away_player: player
    end

    let!(:home_match) do
      FactoryGirl.create :match,
        home_player: player
    end

    let(:player) { FactoryGirl.create :player }

    it "includes both home and away matches" do
      expect(subject).to match_array [home_match, away_match]
    end
  end

  describe "#losses" do
    subject { player.losses }

    let!(:win) do
      FactoryGirl.create :complete_match,
        away_player: player,
        victor: player
    end

    let!(:loss) do
      FactoryGirl.create :complete_match,
        away_player: player
    end

    let!(:incomplete_match) do
      FactoryGirl.create :match,
        home_player: player
    end

    let(:player) { FactoryGirl.create :player }

    specify { expect(subject).to match_array [loss] }
  end

  describe "#matches_against" do
    subject { player.matches_against opponent }

    let(:player) { FactoryGirl.create :player }
    let(:opponent) { FactoryGirl.create :player }

    let!(:incomplete_match) do
      FactoryGirl.create :match,
        home_player: opponent,
        away_player: player
    end

    let!(:away) do
      FactoryGirl.create :complete_match,
        home_player: opponent,
        away_player: player
    end

    let!(:home) do
      FactoryGirl.create :complete_match,
        home_player: player,
        away_player: opponent
    end

    let!(:other) do
      FactoryGirl.create :complete_match
    end

    it { is_expected.to match_array [away, home] }
  end
end
