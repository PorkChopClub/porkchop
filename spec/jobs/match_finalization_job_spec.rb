require 'rails_helper'

RSpec.describe MatchFinalizationJob, type: :job do
  describe "#perform" do
    subject { described_class.new.perform match }

    let(:victor) do
      FactoryGirl.create :player, name: "Candice"
    end

    let(:loser) do
      FactoryGirl.create :player, name: "Shirley"
    end

    let(:match) do
      FactoryGirl.create :complete_match,
        away_player: loser, away_score: 10,
        home_player: victor,  home_score: 12
    end

    let(:notifier) { instance_double Slack::Notifier }
    let(:adjustment) { instance_double EloAdjustment }
    let(:achievement) { instance_double Achievement }

    before do
      allow(ENV).
        to receive(:[]).
        with("SLACK_WEBHOOK_URL").
        and_return("http://en.wikipedia.org/wiki/Candice_Bergen")

      allow(Slack::Notifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:ping)

      allow(EloAdjustment).to receive(:new).and_return(adjustment)
      allow(adjustment).to receive(:adjust!)
    end

    it "notifies Slack about the match" do
      expect(Slack::Notifier).to receive(:new).with(
        "http://en.wikipedia.org/wiki/Candice_Bergen",
        username: "PorkChop",
        icon_emoji: ":trophy:"
      ).and_return(notifier)

      expect(notifier).to receive(:ping).with(
        "Candice defeated Shirley",
        attachments: [{
          fallback: "Candice 12 - 10 Shirley",
          fields: [
            { title: "Candice", value: 12 },
            { title: "Shirley", value: 10 }
          ]
        }]
      )

      subject
    end

    it "adjusts the elo" do
      expect(EloAdjustment).to receive(:new).with(
        victor: victor,
        loser: loser
      ).and_return(adjustment)
      expect(adjustment).to receive(:adjust!)
      subject
    end

    it "collects all of the achievements" do
      expect(match.home_player).to receive(:unearned_achievements).
        and_return([achievement])
      expect(match.away_player).to receive(:unearned_achievements).
        and_return([achievement])
      expect(achievement).to receive(:earned?).twice.and_return(false)
      subject
    end
  end
end
