require 'rails_helper'

RSpec.describe MatchFinalizationJob, type: :job do
  describe "#perform" do
    subject { described_class.new.perform match }

    let(:match) do
      instance_double Match,
                      finalized?: finalized,
                      finished?: finished,
                      leader: "Winnie",
                      victor: "Winnie",
                      loser: "Waldo",
                      all_matches_before: [:match]
    end

    context "when the match hasn't been finalized" do
      let(:finalized) { false }

      context "when the match is finished" do
        let(:finished) { true }
        let(:adjustment_double) { instance_double EloAdjustment }
        let(:win_adjustment_double) { instance_double Stats::StreakAdjustment }
        let(:loss_adjustment_double) { instance_double Stats::StreakAdjustment }
        let(:notification_double) { instance_double SlackNotification }

        it "performs match finalization" do
          expect(match).to receive(:victor=).with("Winnie")
          expect(match).to receive(:finalize!)

          expect(EloAdjustment).
            to receive(:new).
            with(victor: "Winnie", loser: "Waldo", matches: [:match]).
            and_return(adjustment_double)
          expect(adjustment_double).to receive(:adjust!)

          expect(Stats::StreakAdjustment).
            to receive(:new).
            with(player: "Winnie", match_result: "W").
            and_return(win_adjustment_double)
          expect(Stats::StreakAdjustment).
            to receive(:new).
            with(player: "Waldo", match_result: "L").
            and_return(loss_adjustment_double)
          expect(win_adjustment_double).to receive(:adjust!)
          expect(loss_adjustment_double).to receive(:adjust!)

          expect(Match).to receive(:setup!)

          expect(SlackGameEndJob).
            to receive(:perform_later).
            with(match)

          subject
        end
      end

      context "when the match isn't finished" do
        let(:finished) { false }

        it "doesn't do anything" do
          expect(match).not_to receive :finalize!
          subject
        end
      end
    end

    context "when the match is already finalized" do
      let(:finalized) { true }
      let(:finished) { true }

      it "doesn't do anything" do
        expect(match).not_to receive :finalize!
        subject
      end
    end
  end
end
