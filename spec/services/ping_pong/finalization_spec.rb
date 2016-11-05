require 'rails_helper'

RSpec.describe PingPong::Finalization do
  let(:finalization) do
    described_class.new ping_pong_match
  end

  describe "#finalize!" do
    subject { finalization.finalize!(async: async) }

    let(:ping_pong_match) do
      instance_double PingPong::Match, __getobj__: match
    end
    let(:match) { instance_double Match }

    context "when async true" do
      let(:async) { true }

      it "performs match finalization asynchronously" do
        expect(MatchFinalizationJob).to receive(:perform_later).with(match)
        expect(subject).to eq true
      end
    end

    context "when async false" do
      let(:async) { false }

      it "performs match finalization asynchronously" do
        expect(MatchFinalizationJob).to receive(:perform_now).with(match)
        expect(subject).to eq true
      end
    end
  end
end
