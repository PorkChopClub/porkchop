require 'rails_helper'

RSpec.describe PingPong::Finalization do
  let(:finalization) do
    described_class.new PingPong::Match.new(match)
  end

  describe "#finalize!" do
    subject { finalization.finalize! }

    shared_examples "failure" do
      it "doesn't change the finalized at" do
        expect{subject}.not_to change{match.reload.finalized_at}
      end

      it "doesn't set the victor" do
        expect{subject}.not_to change{match.reload.victor}
      end
    end

    context "when the match is already finalized" do
      let(:match) { FactoryGirl.create :complete_match }
      it_behaves_like "failure"
      it { is_expected.to eq true }
    end

    context "when the match is not finished" do
      let(:match) { FactoryGirl.create :match, home_score: 4, away_score: 2 }
      it_behaves_like "failure"
      it { is_expected.to eq false }
    end

    context "when the match is finished but not finalized" do
      let(:victor) { FactoryGirl.create :player }
      let(:loser) { FactoryGirl.create :player }

      let(:match) {
        FactoryGirl.create :match,
          away_player: victor, away_score: 12,
          home_player: loser,  home_score: 10
      }

      before do
        expect(MatchFinalizationJob).
          to receive(:perform_later).
          with(match)
      end

      it { is_expected.to eq true }

      it "sets the finalized_at" do
        expect{subject}.to change{match.reload.finalized_at}
      end

      it "sets the victor" do
        expect{subject}.
          to change{match.reload.victor}.
          from(nil).to(victor)
      end
    end
  end
end
