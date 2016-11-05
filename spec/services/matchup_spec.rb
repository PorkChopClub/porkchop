require 'rails_helper'

RSpec.describe Matchup do
  let(:candice) { FactoryGirl.create :player, name: "Candice Bergen" }
  let(:joseph) { FactoryGirl.create :player, name: "Joseph Gordon-Levitt" }
  let(:zooey) { FactoryGirl.create :player, name: "Zooey Deschanel" }

  describe ".all" do
    subject { Matchup.all(players: players) }

    let(:players) { [candice, joseph, zooey] }

    it "returns all the matchups between the given players" do
      expect(subject).to match_array [
        Matchup.new(candice, joseph),
        Matchup.new(candice, zooey),
        Matchup.new(zooey, joseph)
      ]
    end
  end

  describe "#valid?" do
    subject { matchup.valid? }

    let(:matchup) do
      Matchup.new(*players)
    end

    context "when there is less than two players" do
      let(:players) { [zooey] }
      it { is_expected.to be_falsy }
    end

    context "when the players are the same" do
      let(:players) { [zooey, zooey] }
      it { is_expected.to be_falsy }
    end

    context "when ther are more than two players" do
      let(:players) { [candice, zooey, joseph] }
      it { is_expected.to be_falsy }
    end

    context "when there are two different players" do
      let(:players) { [candice, zooey] }
      it { is_expected.to be_truthy }
    end
  end

  describe "#==" do
    subject { matchup1 == matchup2 }

    context "when the other object is not a matchup" do
      let(:matchup1) { described_class.new(candice, joseph) }
      let(:matchup2) { "I've made a huge mistake." }
      it { is_expected.to be_falsy }
    end

    context "when the players are different" do
      let(:matchup1) { described_class.new(candice, joseph) }
      let(:matchup2) { described_class.new(zooey, joseph) }
      it { is_expected.to be_falsy }
    end

    context "when the matchups contain the same two players" do
      let(:matchup1) { described_class.new(joseph, zooey) }
      let(:matchup2) { described_class.new(zooey, joseph) }
      it { is_expected.to be_truthy }
    end
  end

  describe "#matches_since_last_played" do
    subject { matchup.matches_since_last_played }

    let(:matchup) { described_class.new(candice, joseph) }

    context "when the matchup has never been played" do
      it { is_expected.to eq Float::INFINITY }
    end

    context "when the matchup has been played" do
      before do
        FactoryGirl.create(:complete_match,
                           created_at: 5.days.ago.at_end_of_day,
                           home_player: candice,
                           away_player: joseph)
        FactoryGirl.create(:complete_match,
                           created_at: 4.days.ago.at_end_of_day,
                           home_player: candice,
                           away_player: joseph)
        FactoryGirl.create(:complete_match,
                           created_at: 3.days.ago.at_end_of_day,
                           home_player: zooey,
                           away_player: candice)
        FactoryGirl.create(:complete_match,
                           created_at: 2.days.ago.at_end_of_day,
                           home_player: joseph,
                           away_player: zooey)
      end

      it { is_expected.to eq 2 }
    end
  end

  describe "#match_history" do
    subject { matchup.match_history }

    let(:matchup) { described_class.new(candice, joseph) }

    context "when the matchup has never been played" do
      it { is_expected.to eq [] }
    end

    context "when the matchup has been played" do
      let(:match1) do
        FactoryGirl.create(:complete_match,
                           created_at: 120.days.ago.at_end_of_day,
                           finalized_at: 120.days.ago.at_end_of_day,
                           home_player: candice,
                           away_player: joseph)
      end

      let(:match2) do
        FactoryGirl.create(:complete_match,
                           created_at: 100.days.ago.at_end_of_day,
                           finalized_at: 100.days.ago.at_end_of_day,
                           home_player: candice,
                           away_player: joseph)
      end

      let(:other_match) do
        FactoryGirl.create(:complete_match,
                           created_at: 80.days.ago.at_end_of_day,
                           home_player: joseph,
                           away_player: candice)
      end

      it { is_expected.to eq [match1, match2] }
    end
  end
end
