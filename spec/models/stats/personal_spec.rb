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
      expect(subject).to eq("Georgie" => 0.0,
                            "Shirley" => 0.333,
                            "Candice" => 1.0)
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
end
