require 'rails_helper'

RSpec.describe SlackNotification do
  describe "#deliver" do
    subject { notification.deliver }

    let(:notification) { described_class.new(match) }
    let(:match) do
      instance_double(
        Match,
        victor: victor,
        loser: loser,
        home_player: loser,
        away_player: victor,
        home_score: 0,
        away_score: 11
      )
    end
    let(:notifier_double) { instance_double Slack::Notifier }
    let(:victor) { instance_double(Player, name: "Jared") }
    let(:loser) { instance_double(Player, name: "Kevin") }

    before do
      ENV["SLACK_WEBHOOK_URL"] = "waldo"

      allow(Slack::Notifier).
        to receive(:new).
        and_return(notifier_double)
    end

    after do
      ENV["SLACK_WEBHOOK_URL"] = nil
    end

    it "notifies the things" do
      expect(notifier_double).to receive(:ping).with(
        "Jared defeated Kevin",
        attachments: [
          {
            fallback: "Kevin 0 - 11 Jared",
            fields: [
              { title: "Kevin", value: 0 },
              { title: "Jared", value: 11 }
            ]
          }
        ]
      )
      subject
    end
  end
end
