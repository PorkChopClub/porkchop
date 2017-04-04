require 'rails_helper'

RSpec.describe MatchFinalizationJob, type: :job do
  describe "#perform" do
    subject { described_class.new.perform match }

    context "when the match is finished but not finalized" do
      let(:match) { create :match, :finished }

      it "records the victor" do
        expect { subject }.
          to change { match.victor }.
          from(nil).to(match.home_player)
      end

      it "awards victors's experience" do
        expect { subject }.
          to change { match.home_player.xp }.
          from(0).to(135)
      end

      it "awards the loser's experience" do
        expect { subject }.
          to change { match.away_player.xp }.
          from(0).to(100)
      end

      it "finalizes the match" do
        expect { subject }.
          to change { match.finalized? }.
          from(false).to(true)
      end

      it "updates the streaks" do
        expect(match.home_player.current_streak).to be_nil
        expect(match.away_player.current_streak).to be_nil
        subject
        expect(match.home_player.current_streak).to be_a Stats::Streak
        expect(match.away_player.current_streak).to be_a Stats::Streak
      end

      it "updates the elo ratings" do
        expect(match.home_player.elo).to eq 1000
        expect(match.away_player.elo).to eq 1000
        subject
        expect(match.home_player.elo).to eq 1020
        expect(match.away_player.elo).to eq 980
      end

      it "sends a Slack notification" do
        expect(SlackGameEndJob).to receive(:perform_later).with(match)
        subject
      end

      it "broadcasts an update" do
        expect(OngoingMatchChannel).to receive(:broadcast_update)
        subject
      end

      it "sets up a new match" do
        expect(Match).to receive(:setup!)
        subject
      end
    end

    context "when the match isn't finished" do
      let(:match) { create :match }

      it "doesn't do anything" do
        expect { subject }.not_to change { match.finalized? }.from(false)
      end
    end

    context "when the match is already finalized" do
      let(:match) { create :complete_match }

      it "doesn't do anything" do
        expect { subject }.not_to change { match.home_player.elo }.from(1000)
        subject
      end
    end
  end
end
