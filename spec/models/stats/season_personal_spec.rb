require 'rails_helper'

RSpec.describe Stats::SeasonPersonal do
  let(:stats) { described_class.new(season, player) }
  let(:season) { FactoryGirl.create :season }
  let(:player) { FactoryGirl.create :player }

  before do
    FactoryGirl.create :complete_match, home_player: player, season: season
    FactoryGirl.create :complete_match, home_player: player, season: season
    FactoryGirl.create :complete_match, away_player: player, season: season
  end

  describe "#matches_played" do
    subject { stats.matches_played }
    it { is_expected.to eq 3 }
  end

  describe "#matches_won" do
    subject { stats.matches_won }
    it { is_expected.to eq 2 }
  end

  describe "#matches_lost" do
    subject { stats.matches_lost }
    it { is_expected.to eq 1 }
  end

  describe "#win_ratio" do
    subject { stats.win_ratio }

    context "when the player has played games" do
      it { is_expected.to eq ".667" }
    end

    context "when the player has not played any games" do
      let(:other) { FactoryGirl.create :player }
      let(:stats) { described_class.new(season, other) }
      it { is_expected.to eq ".000" }
    end
  end
end
