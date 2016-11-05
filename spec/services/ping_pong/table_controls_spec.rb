require 'rails_helper'

RSpec.describe PingPong::TableControls do
  let(:home_player) { instance_double Player }
  let(:away_player) { instance_double Player }
  let(:match) { double PingPong::Match, home_player: home_player, away_player: away_player, finalized?: finalized, finished?: finished }
  let(:finished) { false }
  let(:finalized) { false }
  let(:table) { described_class.new(match) }

  shared_examples "a player button" do
    context 'game ongoing' do
      let(:service) { instance_double PingPong::Service }
      it "scores a point" do
        expect(PingPong::Service).
          to receive(:new).
          and_return(service)
        expect(service).
          to receive(:record!)
        subject
      end
    end

    context 'game awaiting finalization' do
      let(:finished) { true }

      it "finalizes the match" do
        expect(MatchFinalizationJob).
          to receive(:perform_later).
          with(match)
        subject
      end
    end
  end

  describe "#home_button" do
    subject { table.home_button }
    it_behaves_like "a player button"
  end

  describe "#away_button" do
    subject { table.away_button }
    it_behaves_like "a player button"
  end

  describe "#center_button" do
    let(:rewind) { instance_double PingPong::Rewind }
    it "rewinds the match" do
      expect(PingPong::Rewind).
        to receive(:new).
        with(match).
        and_return(rewind)
      expect(rewind).
        to receive(:rewind!)
      table.center_button
    end
  end
end
