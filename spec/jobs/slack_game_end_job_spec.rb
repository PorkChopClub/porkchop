require 'rails_helper'

RSpec.describe SlackGameEndJob do
  describe "#perform" do
    subject { described_class.new.perform game }

    let(:game) do
      instance_double(
        Match,
        victor: victor,
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
      allow(Slack::Notifier).
        to receive(:new).
        with("http://example.com/slack",
             username: "PorkChop",
             icon_emoji: ":trophy:").
        and_return(notifier_double)
    end

    it "notifies the things" do
      expect(notifier_double).
        to receive(:ping).
        with("Jared defeated Kevin, 11 to 0")

      subject
    end
  end
end
