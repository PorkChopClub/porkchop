require 'rails_helper'

RSpec.describe PingPong::Service do
  describe "#record!" do
    let(:service) {
      described_class.new(
        match: PingPong::Match.new(match),
        victor: victor
      )
    }

    let(:match) {
      FactoryGirl.create :match,
        home_player: home_player,
        away_player: away_player,
        home_score: 1
    }
    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }
    let(:victor) { home_player }

    subject { service.record! }

    it "records a point for that player" do
      expect{subject}.
        to change{match.home_points.count}.
        from(1).to(2)
    end
  end
end
