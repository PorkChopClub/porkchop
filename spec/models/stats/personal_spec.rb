require 'rails_helper'

RSpec.describe Stats::Personal do
  let(:stats) { described_class.new(player) }
  let(:player) { FactoryGirl.create :player }

  describe "#record_against" do
    subject { stats.record_against candice }

    let(:candice) { FactoryGirl.create :player, name: "Candice" }

    let!(:match1) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         away_player: candice
    end

    let!(:match2) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         away_player: candice
    end

    let!(:match3) do
      FactoryGirl.create :complete_match,
                         home_player: candice,
                         away_player: player
    end

    it { is_expected.to eq [2, 1] }
  end

  describe "#win_ratio_by_opponent" do
    subject { stats.win_ratio_by_opponent }

    let(:candice) { FactoryGirl.create :player, name: "Candice" }
    let(:shirley) { FactoryGirl.create :player, name: "Shirley" }
    let(:georgie) { FactoryGirl.create :player, name: "Georgie" }

    let!(:match1) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         away_player: candice
    end

    let!(:match2) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         away_player: candice
    end

    let!(:match3) do
      FactoryGirl.create :complete_match,
                         home_player: shirley,
                         away_player: player
    end

    let!(:match4) do
      FactoryGirl.create :complete_match,
                         home_player: shirley,
                         away_player: player
    end

    let!(:match5) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         away_player: shirley
    end

    let!(:match6) do
      FactoryGirl.create :complete_match,
                         home_player: georgie,
                         away_player: player
    end

    it "is a hash of the win ratios by opponents" do
      expect(subject).to eq(candice => 1.0,
                            shirley => 0.333,
                            georgie => 0.0)
    end
  end

  describe "#win_ratio" do
    subject { stats.win_ratio }

    context "when the player has played games" do
      let!(:match1) do
        FactoryGirl.create :complete_match, home_player: player
      end

      let!(:match2) do
        FactoryGirl.create :complete_match, home_player: player
      end

      let!(:match3) do
        FactoryGirl.create :complete_match, away_player: player
      end

      it { is_expected.to eq 0.667 }
    end

    context "when the player has not played any games" do
      it { is_expected.to eq 0.0 }
    end
  end

  describe "#record" do
    subject { stats.record }

    let!(:match1) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         victor: player
    end

    let!(:match2) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         victor: player
    end

    let!(:match3) do
      FactoryGirl.create :complete_match,
                         away_player: player
    end

    it { is_expected.to eq [2, 1] }
  end

  describe "#last_10_results" do
    subject { stats.last_10_results }

    before do
      FactoryGirl.create_list :complete_match, 2, home_player: player
      FactoryGirl.create :complete_match, away_player: player
    end

    it { is_expected.to eq [2, 1] }
  end

  describe "#highest_elo_rating" do
    subject { stats.highest_elo_rating }

    before do
      FactoryGirl.create :elo_rating,
                         player: player,
                         rating: 1100
    end

    it { is_expected.to eq 1100 }
  end

  describe "#lowest_elo_rating" do
    subject { stats.lowest_elo_rating }

    before do
      FactoryGirl.create :elo_rating,
                         player: player,
                         rating: 900
    end

    it { is_expected.to eq 900 }
  end

  describe "#longest_winning_streak" do
    subject { stats.longest_winning_streak }

    before do
      FactoryGirl.create_list :streak, 2, :finished, player: player
      FactoryGirl.create :streak, streak_length: 4, player: player
    end

    it { is_expected.to eq 4 }
  end

  describe "#longest_losing_streak" do
    subject { stats.longest_losing_streak }

    before do
      FactoryGirl.create_list :streak,
                              2,
                              :finished,
                              player: player,
                              streak_type: "L"
      FactoryGirl.create :streak,
                         streak_length: 5,
                         streak_type: "L",
                         player: player
    end

    it { is_expected.to eq 5 }
  end
end
