require 'rails_helper'

RSpec.describe PingPong::Service do
  describe "#record!" do
    let(:service) do
      described_class.new(
        match: match,
        victor: victor
      )
    end

    let(:match) do
      FactoryGirl.create :match, home_score: 1, away_score: 0
    end
    let(:home_player) { match.home_player }
    let(:away_player) { match.away_player }
    let(:victor) { home_player }

    subject { service.record! }

    it "records a point for that player" do
      expect { subject }.
        to change { match.home_points.count }.
        from(1).to(2)
    end

    context 'at start' do
      let(:match) { FactoryGirl.create :match, :at_start }

      it "sets service for that player" do
        expect { subject }.
          to change { match.first_service_by_home_player? }.
          from(false).to(true)
      end
    end
  end
end
