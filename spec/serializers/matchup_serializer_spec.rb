require "rails_helper"

RSpec.describe MatchupSerializer do
  describe "#player_names" do
    subject { described_class.new(matchup).player_names }

    let(:jessica) { create :player, name: "Jessica Jones" }
    let(:luke) { create :player, name: "Luke Cage" }
    let(:matchup) { Matchup.new(jessica, luke) }

    context "when two players have never played against each other" do
      it "displays players in alphabetical order" do
        expect(subject).to eq ["Jessica Jones", "Luke Cage"]
      end
    end

    context "when Jessica Jones should be the home player" do
      before do
        create(
          :complete_match,
          home_player: luke,
          away_player: jessica,
          finalized_at: 1.week.ago
        )
      end

      it "returns Jessica Jones as the first player" do
        expect(subject).to eq ["Jessica Jones", "Luke Cage"]
      end
    end

    context "when Jessica Jones should be the away player" do
      before do
        create(
          :match,
          home_player: jessica,
          away_player: luke,
          finalized_at: 2.weeks.ago
        )
      end

      it "returns Luke Cage as the first player" do
        expect(subject).to eq ["Luke Cage", "Jessica Jones"]
      end
    end
  end
end
