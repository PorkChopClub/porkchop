require 'rails_helper'

RSpec.describe SlackMessage do
  describe "#send!" do
    subject { message.send! }

    let(:message) { described_class.new(*args) }
    let(:args) { [:a, { number: 2 }] }
    let(:notifier_double) { instance_double Slack::Notifier }

    it "delegates to Slack::Notifier#ping" do
      allow(Slack::Notifier).
        to receive(:new).
        with("http://example.com/slack",
             username: "PorkChop",
             icon_emoji: ":porkchop:").
        and_return(notifier_double)
      expect(notifier_double).
        to receive(:ping).
        with(:a, number: 2)

      subject
    end
  end
end
