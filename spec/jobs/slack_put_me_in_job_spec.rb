require 'rails_helper'

RSpec.describe SlackPutMeInJob do
  describe "#perform" do
    subject { described_class.new.perform }

    let(:message_double) { instance_double SlackMessage }

    it "notifies the things" do
      allow(SlackMessage).
        to receive(:new).
        with(":table_tennis_paddle_and_ball: There's ping pong to play! <http://porkchop.club/play|Click here to join the queue!> :table_tennis_paddle_and_ball:").
        and_return(message_double)
      expect(message_double).
        to receive(:send!)

      subject
    end
  end
end
