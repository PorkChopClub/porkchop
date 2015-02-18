require 'rails_helper'

RSpec.describe Stats::Personal do
  let(:stats) { described_class.new(player) }

  describe "#win_ratio" do
    subject { stats.win_ratio }

    let(:player) { FactoryGirl.create :player, name: "Jared" }

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
end
