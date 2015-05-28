require 'rails_helper'
require 'matchmaker'

RSpec.describe Matchmaker do
  describe "#choose" do
    let(:matchmaker) { Matchmaker.new(players) }
    let(:least_recently_played_player) { FactoryGirl.create :player, name: "Least", active: true }

    subject { matchmaker.choose }

    context "when there are no players" do
      let(:players) { [] }

      it { is_expected.to be_a Matchup }
      it { is_expected.not_to be_valid }
    end

    context "when there are 2 players" do
      let(:other_player) { FactoryGirl.create :player, active: true }
      let(:players) { [least_recently_played_player, other_player] }

      it { is_expected.to be_a Matchup }
      it { is_expected.to be_valid }
    end

    context "when there are 3 or more players" do
      let(:other_player) { FactoryGirl.create :player, name: "Other", active: true }
      let(:another_player) { FactoryGirl.create :player, name: "Another", active: true }
      let(:players) { [least_recently_played_player, other_player, another_player] }

      it { is_expected.to be_a Matchup }
      it { is_expected.to be_valid }
    end

    # FIXME: Add tests that do what Hawth's tests did, but work with ActiveRecord.
  end
end
