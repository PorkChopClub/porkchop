require 'rails_helper'
require 'matchmaker'

RSpec.describe Matchmaker do
  describe "#choose" do
    let(:matchmaker) { Matchmaker.new(players) }
    let(:least_recently_played_player) { FactoryGirl.create :player, name: "Least", active: true }

    subject { matchmaker.choose }

    context "when there are 2 players"do
      let(:other_player) { FactoryGirl.create :player, active: true }
      let(:players) { [least_recently_played_player, other_player] }

      before do
        FactoryGirl.create(:match, :finalized, home_player: other_player)
      end

      it { is_expected.to eq [least_recently_played_player, other_player] }
    end

    context "when there are 3 or more players" do
      let(:other_player) { FactoryGirl.create :player, name: "Other", active: true }
      let(:another_player) { FactoryGirl.create :player, name: "Another", active: true }
      let(:players) { [least_recently_played_player, other_player, another_player] }

      before do
        FactoryGirl.create(:match, :finalized,
                           home_player: least_recently_played_player,
                           away_player: another_player,
                           created_at: 2.days.ago)

        FactoryGirl.create(:match, :finalized,
                           home_player: other_player,
                           away_player: another_player,
                           created_at: 2.minutes.ago)
      end

      it { is_expected.to eq [least_recently_played_player, other_player] }
    end
  end
end
