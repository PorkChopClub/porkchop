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
    let(:victor) { instance_double(Player, name: "Jared") }
    let(:loser) { instance_double(Player, name: "Kevin") }
    let(:message_double) { instance_double SlackMessage }

    it "notifies the things" do
      allow(SlackMessage).
        to receive(:new).
        with(":trophy: Jared defeated Kevin, 11 to 0 :trophy:").
        and_return(message_double)
      expect(message_double).
        to receive(:send!)

      subject
    end
  end
end
