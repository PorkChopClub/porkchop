require 'rails_helper'

RSpec.describe PingPong::Commentator do
  let(:commentator) do
    described_class.new match: PingPong::Match.new(match)
  end

  describe "#comment" do
    subject { commentator.comment }

    let(:jared) { FactoryGirl.create :player, name: "Jared" }
    let(:gray)  { FactoryGirl.create :player, name: "Gray" }

    context "when the match is less than 2 points in" do
      let(:match) do
        FactoryGirl.create :new_match,
          home_player: jared,
          away_player: gray
      end

      context "when these players have played before" do
        let!(:older_match) do
          FactoryGirl.create :complete_match,
            home_player: jared, home_score: 12,
            away_player: gray,  away_score: 14,
            finalized_at: 2.days.ago
        end

        let!(:last_match) do
          FactoryGirl.create :complete_match,
            home_player: jared, home_score: 11,
            away_player: gray,  away_score: 3,
            finalized_at: 1.day.ago
        end

        it { is_expected.
             to eq "In their last match, Jared won 11-3." }
      end

      context "when these players have not played before" do
        it { is_expected.
             to eq "This is the first match between these players." }
      end
    end
  end
end
