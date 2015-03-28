require 'rails_helper'

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

  describe "#finished?" do
    let(:match) do
      FactoryGirl.create :match,
                         home_score: home_score,
                         away_score: away_score
    end

    subject { ping_pong_match.finished? }

    context "when a player has won at 11" do
      let(:home_score) { 11 }
      let(:away_score) { 9 }

      it { is_expected.to eq true }
    end

    context "when a player has won past 11" do
      let(:home_score) { 11 }
      let(:away_score) { 13 }

      it { is_expected.to eq true }
    end

    context "when the game can't be finished" do
      let(:home_score) { 10 }
      let(:away_score) { 9 }

      it { is_expected.to eq false }
    end
  end

  describe "#leader" do
    subject { ping_pong_match.leader }

    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }

    context "when the game is tied" do
      let(:match) do
        FactoryGirl.create :match,
                           home_player: home_player,
                           away_player: away_player,
                           home_score: 5,
                           away_score: 5
      end
      it { is_expected.to eq nil }
    end

    context "when the home player is leading" do
      let(:match) do
        FactoryGirl.create :match,
                           home_player: home_player,
                           away_player: away_player,
                           home_score: 6,
                           away_score: 5
      end
      it { is_expected.to eq home_player }
    end

    context "when the away player is leading" do
      let(:match) do
        FactoryGirl.create :match,
                           home_player: home_player,
                           away_player: away_player,
                           home_score: 5,
                           away_score: 6
      end
      it { is_expected.to eq away_player }
    end
  end

  describe "#comment" do
    subject { ping_pong_match.comment }
    let(:match) { FactoryGirl.create :match }
    let(:commentator) { instance_double PingPong::Commentator }

    before do
      expect(PingPong::Commentator).
        to receive(:new).
          with(match: match) { commentator }

      expect(commentator).to receive(:comment) { 'foo' }
    end

    it { is_expected.to eq 'foo' }
  end
end
