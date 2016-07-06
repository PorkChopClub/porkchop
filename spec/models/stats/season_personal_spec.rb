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

  describe "#<=>" do
    let!(:other) { described_class.new(season, other_player) }
    let(:other_player) { FactoryGirl.create :player }
    before do
      FactoryGirl.create :complete_match, home_player: other_player, season: season
    end
    context "when they have the same win ratio" do
      subject { stats <=> other }
      it { is_expected.to eq -1 }
    end
    context "when the win ratio is the same" do
      before do
        FactoryGirl.create :complete_match, home_player: other_player, season: season
        FactoryGirl.create :complete_match, away_player: other_player, season: season, away_score: 2
      end
      subject { stats <=> other }
      it { is_expected.to eq 1 }
    end
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

  describe "#points_for" do
    subject { stats.points_for }
    it { is_expected.to eq 28 }
  end

  describe "#points_against" do
    subject { stats.points_against }
    it { is_expected.to eq 23 }
  end

  describe "#point_differential" do
    subject { stats.point_differential }
    it { is_expected.to eq 5 }
  end

  describe "#games_back" do
    subject { stats.games_back }
    it { is_expected.to eq nil }
  end
end
