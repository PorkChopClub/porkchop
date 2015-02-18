require 'rails_helper'

RSpec.describe Stats::Personal do
  let(:stats) { described_class.new(player) }
  let(:player) { FactoryGirl.create :player }

  describe "#win_ratio" do
    subject { stats.win_ratio }

    context "when the player has played games" do
      let!(:match1) {
        FactoryGirl.create :match, home_player: player, victor: player
      }
      let!(:match2) {
        FactoryGirl.create :match, home_player: player, victor: player
      }
      let!(:match3) { FactoryGirl.create :match, home_player: player }

      it { is_expected.to eq 0.667 }
    end

    context "when the player has not played any games" do
      it { is_expected.to eq 0.0 }
    end
  end

  describe "#record" do
    subject { stats.record }

    let!(:match1) {
      FactoryGirl.create :complete_match, home_player: player, victor: player
    }
    let!(:match2) {
      FactoryGirl.create :complete_match, home_player: player, victor: player
    }
    let!(:match3) { FactoryGirl.create :complete_match, away_player: player }

    it { is_expected.to eq [2, 1] }
  end
end
