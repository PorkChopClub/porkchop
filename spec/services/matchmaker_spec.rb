require 'rails_helper'

RSpec.describe Matchmaker do
  describe "#choose" do
    let(:matchmaker) { Matchmaker.new(players) }
    let(:least_recently_played_player) do
      FactoryGirl.create :player, name: "Least", active: true
    end

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
  end

  describe "explain" do
    subject { matchmaker.explain }

    let(:matchmaker) { Matchmaker.new(players) }
    let(:players) { [bert, ernie] }
    let(:ernie) { FactoryGirl.create :player, name: "Ernie", elo: 400, active: true }
    let(:bert) { FactoryGirl.create :player, name: "Bert", elo: 1200, active: true }

    it "returns an arbitrary representation of the result of the matchup ranking" do
      expect(subject).to eq [{
        players: %w(Bert Ernie),
        result: 3.66,
        breakdown: [
          {
            name: "Matchup matches since last played",
            base_value: Float::INFINITY,
            max: 2.0,
            factor: 0.33,
            value: 0.66
          },
          {
            name: "Combined matches since players last played",
            base_value: Float::INFINITY,
            max: 2.0,
            factor: 1.5,
            value: 3.0
          }
        ]
      }]
    end
  end

  describe "matchmaking algorithm" do
    context "with 5 players playing 80 matches" do
      let!(:players) { FactoryGirl.create_list(:player, 5, active: true) }
      before do
        create :default_table
        80.times { Match.setup!.finalize! }
      end

      it "plays all matchups" do
        Player.find_each do |player|
          expect(player.matches.count).to be_within(2).of 32
        end
      end
    end
  end
end
