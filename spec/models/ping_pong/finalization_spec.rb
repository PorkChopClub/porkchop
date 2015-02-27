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
      let(:victor) do
        FactoryGirl.create :player, name: "Candice"
      end

      let(:loser) do
        FactoryGirl.create :player, name: "Shirley"
      end

      let(:match) {
        FactoryGirl.create :match,
          away_player: victor, away_score: 12,
          home_player: loser,  home_score: 10
      }

      let(:notifier) { instance_double Slack::Notifier }

      before do
        allow(ENV).
          to receive(:[]).
          with("SLACK_WEBHOOK_URL").
          and_return("http://en.wikipedia.org/wiki/Candice_Bergen")

        expect(Slack::Notifier).
          to receive(:new).
          with(
            "http://en.wikipedia.org/wiki/Candice_Bergen",
            username: "PorkChop",
            icon_emoji: ":trophy:"
          ).and_return(notifier)

        expect(notifier).
          to receive(:ping).
          with(
            "Candice defeated Shirley",
            attachments: [
              {
                fields: [
                  {
                    title: "Shirley",
                    value: 10
                  },
                  {
                    title: "Candice",
                    value: 12
                  }
                ]
              }
            ]
          )
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
