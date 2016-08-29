require 'rails_helper'
require 'timecop'

RSpec.describe PingPong::Match do
  let(:ping_pong_match) { described_class.new match }

  describe "#game_point" do
    subject { ping_pong_match.game_point }

    let(:match) do
      FactoryGirl.create :match,
                         home_score: home_score,
                         away_score: away_score
    end

    context "when it is game point for the home player" do
      let(:home_score) { 10 }
      let(:away_score) { 0 }
      it { is_expected.to eq :home }
    end

    context "when it is game point for the away player" do
      let(:home_score) { 12 }
      let(:away_score) { 13 }
      it { is_expected.to eq :away }
    end

    context "when it is not game point" do
      let(:home_score) { 10 }
      let(:away_score) { 10 }
      it { is_expected.to eq nil }
    end
  end

  describe "#home_player_service?" do
    subject { ping_pong_match.home_player_service? }

    let(:match) { FactoryGirl.build :match, :at_start }

    context "when it's the first service of the match" do
      context "and the service is undecided" do
        it { is_expected.to be nil }
      end

      context "and the away player serves first" do
        before { match.first_service_by_away_player! }
        it { is_expected.to be false }
      end

      context "and the home player serves first" do
        before { match.first_service_by_home_player! }
        it { is_expected.to be true }
      end
    end

    context "when it's the third service of the match" do
      let(:match) do
        FactoryGirl.create :match, home_score: 1, away_score: 1
      end

      context "and the away player serves first" do
        before { match.first_service_by_away_player! }
        it { is_expected.to be true }
      end

      context "and the home player serves first" do
        before { match.first_service_by_home_player! }
        it { is_expected.to be false }
      end
    end

    context "when both players have 10 points" do
      let(:match) do
        FactoryGirl.create :match, home_score: 10, away_score: 10
      end

      context "and the away player serves first" do
        before { match.first_service_by_away_player! }
        it { is_expected.to be false }
        it "alternates every service" do
          FactoryGirl.create :point, match: match, victor: match.home_player
          expect(subject).to be true
        end
      end

      context "and the home player serves first" do
        before { match.first_service_by_home_player! }
        it { is_expected.to be true }
        it "alternates every service" do
          FactoryGirl.create :point, match: match, victor: match.home_player
          expect(subject).to be false
        end
      end
    end
  end

  describe "#away_player_service?" do
    subject { ping_pong_match.away_player_service? }

    let(:match) { FactoryGirl.build :match, :at_start }

    context "when it's the first service of the match" do
      context "and the service is undecided" do
        it { is_expected.to be nil }
      end

      context "and the away player serves first" do
        before { match.first_service_by_away_player! }
        it { is_expected.to be true }
      end

      context "and the home player serves first" do
        before { match.first_service_by_home_player! }
        it { is_expected.to be false }
      end
    end
  end

  describe "#leader" do
    subject { ping_pong_match.leader }

    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }

    let(:match) do
      FactoryGirl.create(:match,
                         home_player: home_player,
                         away_player: away_player,
                         home_score: home_score,
                         away_score: away_score)
    end

    context "when the match is tied" do
      let(:home_score) { 5 }
      let(:away_score) { 5 }
      it { is_expected.to eq nil }
    end

    context "when the home player is leading" do
      let(:home_score) { 6 }
      let(:away_score) { 5 }
      it { is_expected.to eq home_player }
    end

    context "when the away player is leading" do
      let(:home_score) { 5 }
      let(:away_score) { 6 }
      it { is_expected.to eq away_player }
    end
  end

  describe "#trailer" do
    subject { ping_pong_match.trailer }

    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }

    let(:match) do
      FactoryGirl.create(:match,
                         home_player: home_player,
                         away_player: away_player,
                         home_score: home_score,
                         away_score: away_score)
    end

    context "when the match is tied" do
      let(:home_score) { 5 }
      let(:away_score) { 5 }
      it { is_expected.to eq nil }
    end

    context "when the home player is leading" do
      let(:home_score) { 6 }
      let(:away_score) { 5 }
      it { is_expected.to eq away_player }
    end

    context "when the away player is leading" do
      let(:home_score) { 5 }
      let(:away_score) { 6 }
      it { is_expected.to eq home_player }
    end
  end

  describe "#leading_score" do
    subject { ping_pong_match.leading_score }

    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }

    let(:match) do
      FactoryGirl.create(:match,
                         home_player: home_player,
                         away_player: away_player,
                         home_score: home_score,
                         away_score: away_score)
    end

    context "when the match is tied" do
      let(:home_score) { 7 }
      let(:away_score) { 7 }
      it { is_expected.to eq nil }
    end

    context "when the home player is leading" do
      let(:home_score) { 8 }
      let(:away_score) { 7 }
      it { is_expected.to eq 8 }
    end

    context "when the away player is leading" do
      let(:home_score) { 8 }
      let(:away_score) { 9 }
      it { is_expected.to eq 9 }
    end
  end

  describe "#trailing_score" do
    subject { ping_pong_match.trailing_score }

    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }

    let(:match) do
      FactoryGirl.create(:match,
                         home_player: home_player,
                         away_player: away_player,
                         home_score: home_score,
                         away_score: away_score)
    end

    context "when the match is tied" do
      let(:home_score) { 7 }
      let(:away_score) { 7 }
      it { is_expected.to eq nil }
    end

    context "when the home player is trailing" do
      let(:home_score) { 2 }
      let(:away_score) { 7 }
      it { is_expected.to eq 2 }
    end

    context "when the away player is trailing" do
      let(:home_score) { 8 }
      let(:away_score) { 1 }
      it { is_expected.to eq 1 }
    end
  end

  describe "#score_differential" do
    subject { ping_pong_match.score_differential }
    let(:match) do
      FactoryGirl.create(:match,
                         home_score: home_score,
                         away_score: away_score)
    end

    context "when the match is tied" do
      let(:home_score) { 2 }
      let(:away_score) { 2 }
      it { is_expected.to eq 0 }
    end

    context "when the away player is leading" do
      let(:home_score) { 2 }
      let(:away_score) { 9 }
      it { is_expected.to eq 7 }
    end

    context "when the home player is leading" do
      let(:home_score) { 9 }
      let(:away_score) { 4 }
      it { is_expected.to eq 5 }
    end
  end

  describe "#comment" do
    subject { ping_pong_match.comment }
    let(:match) { FactoryGirl.create :match }
    let(:commentator) { instance_double PingPong::Commentator }

    before do
      expect(PingPong::Commentator).
        to receive(:new).
        and_return(commentator)

      expect(commentator).to receive(:comment) { 'foo' }
    end

    it { is_expected.to eq 'foo' }
  end

  describe "#warmup?" do
    subject { ping_pong_match.warmup? }

    context "when service isn't selected" do
      let(:match) { FactoryGirl.create :match, first_service: nil }

      context "when the game was created less than 90 seconds ago" do
        it { is_expected.to be_truthy }
      end

      context "when the game was created more than 90 seconds ago" do
        before { match.created_at = 91.seconds.ago }
        it { is_expected.to be_falsy }
      end
    end

    context "when service is selected" do
      let(:match) { FactoryGirl.create :match }
      it { is_expected.to be_falsy }
    end
  end

  describe "#warmup_seconds_left" do
    subject { ping_pong_match.warmup_seconds_left }

    before { Timecop.freeze }
    after { Timecop.return }

    context "when the game was created less than 90 seconds ago" do
      let(:match) { FactoryGirl.create :match, created_at: 39.seconds.ago }
      it { is_expected.to eq 51 }
    end

    context "when the game was created more than 90 seconds ago" do
      let(:match) { FactoryGirl.create :match, created_at: 99.seconds.ago }
      it { is_expected.to eq 0 }
    end
  end
end
