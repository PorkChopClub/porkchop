require 'rails_helper'

RSpec.describe Matchup do
  let(:candice) { FactoryGirl.create :player, name: "Candice Bergen" }
  let(:joseph) { FactoryGirl.create :player, name: "Joseph Gordon-Levitt" }
  let(:zooey) { FactoryGirl.create :player, name: "Zooey Deschanel" }

  describe "#valid?" do
    subject { matchup.valid? }

    let(:matchup) do
      Matchup.new(home_player: home_player,
                  away_player: away_player)
    end

    context "when home_player is missing" do
      let(:home_player) { nil }
      let(:away_player) { zooey }

      it { is_expected.to be_falsy }
    end

    context "when away_player is missing" do
      let(:home_player) { zooey }
      let(:away_player) { nil }

      it { is_expected.to be_falsy }
    end

    context "when home_player is away_player" do
      let(:home_player) { zooey }
      let(:away_player) { zooey }

      it { is_expected.to be_falsy }
    end

    context "when home_player and away_player are present" do
      let(:home_player) { candice }
      let(:away_player) { zooey }

      it { is_expected.to be_truthy }
    end
  end

  describe "#==" do
    subject { matchup1 == matchup2 }

    context "when the other object is not a matchup" do
      let(:matchup1) { described_class.new(home_player: candice, away_player: joseph) }
      let(:matchup2) { "I've made a huge mistake." }

      it { is_expected.to be_falsy }
    end

    context "when the players are different" do
      let(:matchup1) { described_class.new(home_player: candice, away_player: joseph) }
      let(:matchup2) { described_class.new(home_player: zooey, away_player: joseph) }

      it { is_expected.to be_falsy }
    end

    context "when the matchups contain the same two players" do
      context "in different positions" do
        let(:matchup1) { described_class.new(home_player: joseph, away_player: zooey) }
        let(:matchup2) { described_class.new(home_player: zooey, away_player: joseph) }

        it { is_expected.to be_falsy }
      end

      context "in the same positions" do
        let(:matchup1) { described_class.new(home_player: joseph, away_player: zooey) }
        let(:matchup2) { described_class.new(home_player: joseph, away_player: zooey) }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe "#last_played_at" do
    subject { matchup.last_played_at }

    let(:matchup) { described_class.new(home_player: candice, away_player: joseph) }

    context "when the matchup has never been played" do
      it { is_expected.to eq Time.at(0) }
    end

    context "when the matchup has been played" do
      before do
        FactoryGirl.create(:complete_match,
                           created_at: 120.days.ago.at_end_of_day,
                           home_player: candice,
                           away_player: joseph)
        FactoryGirl.create(:complete_match,
                           created_at: 100.days.ago.at_end_of_day,
                           home_player: candice,
                           away_player: joseph)
        FactoryGirl.create(:complete_match,
                           created_at: 80.days.ago.at_end_of_day,
                           home_player: joseph,
                           away_player: candice)
      end

      it { is_expected.to be_within(1.second).of(100.days.ago.at_end_of_day) }
    end
  end

  describe "#match_history" do
    subject { matchup.match_history }

    let(:matchup) { described_class.new(home_player: candice, away_player: joseph) }

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
