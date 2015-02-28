require 'rails_helper'

RSpec.describe MatchFinalizationJob, type: :job do
  describe "#perform" do
    subject { described_class.perform match }

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
            attachments: [{fields: [{title: "Shirley", value: 10},
                                    {title: "Candice", value: 12}]}]
          )
    end
  end
end
