require 'rails_helper'

RSpec.describe Match, type: :model do
  it { is_expected.to belong_to :home_player }
  it { is_expected.to belong_to :away_player }
  it { is_expected.to belong_to :victor }
  it { is_expected.to belong_to :table }

  it { is_expected.to have_one :season_match }
  it { is_expected.to have_one :season }
  it { is_expected.to have_one :betting_info }

  it { is_expected.to validate_presence_of :home_player }
  it { is_expected.to validate_presence_of :away_player }
  it { is_expected.to validate_presence_of :table }

  describe ".setup!" do
    subject { Match.setup! }

    before { create :default_table }

    let!(:kelly) do
      FactoryGirl.create(:player,
                         active: true,
                         name: "Kelly Clarkson")
    end
    let!(:carrie) do
      FactoryGirl.create(:player,
                         active: true,
                         name: "Carrie Underwood")
    end

    context "when the players have played before" do
      before do
        FactoryGirl.create(:complete_match,
                           home_player: carrie,
                           away_player: kelly)
      end

      it "creates a match" do
        expect { subject }.
          to change { Match.count }.
          from(1).to(2)
      end

      it "alternates who is at home" do
        subject
        expect(subject.home_player).to eq kelly
        expect(subject.away_player).to eq carrie
      end
    end

    context "when the players have not played before" do
      it "creates a match" do
        expect { subject }.
          to change { Match.count }.
          from(0).to(1)
      end

      it "puts the player whose name comes first at home" do
        subject
        expect(subject.home_player).to eq carrie
        expect(subject.away_player).to eq kelly
      end
    end

    context "with an open season (not on rabbits)" do
      let(:season) { FactoryGirl.create(:season) }
      before { season.players = [carrie, kelly] }

      it "associates the match to the season" do
        subject
        expect(subject.season).to eq season
      end
    end
  end

  describe "#betting_info" do
    subject { match.betting_info }

    let(:match) { FactoryGirl.create :match, home_player: kevin, away_player: murphy }
    let(:kevin) { FactoryGirl.create :player, name: "Kevin" }
    let(:murphy) { FactoryGirl.create :player, name: "Murphy" }

    before { FactoryGirl.create_list :complete_match, match_count, home_player: kevin, away_player: murphy }

    context "when the players have played at least 10 games" do
      let(:match_count) { 10 }
      it { is_expected.to be_a BettingInfo }
    end

    context "when the players haven't played at least 10 games" do
      let(:match_count) { 9 }
      it { is_expected.to be_nil }
    end
  end

  describe "#league_match?" do
    subject { match.league_match? }

    context "when the match has a season" do
      let(:match) { FactoryGirl.create :league_match }
      it { is_expected.to be_truthy }
    end

    context "when the match does not have a season" do
      let(:match) { FactoryGirl.create :match }
      it { is_expected.to be_falsy }
    end
  end

  describe "#to_matchup" do
    subject { match.to_matchup }

    let(:match) { FactoryGirl.create(:match) }

    it "builds the match's matchup" do
      expect(subject.players.to_a).to match_array [match.home_player,
                                                   match.away_player]
    end
  end

  describe "#players" do
    let(:match) do
      FactoryGirl.create(:match,
                         home_player: home_player,
                         away_player: away_player)
    end

    let(:home_player) { FactoryGirl.create(:player) }
    let(:away_player) { FactoryGirl.create(:player) }

    subject { match.players }

    it { is_expected.to match_array [home_player, away_player] }
  end

  describe "#destroy" do
    let!(:match) { FactoryGirl.create :match, home_score: 10, away_score: 0 }

    subject { match.destroy }

    it "destroys its points" do
      expect { subject }.
        to change { Point.count }.
        from(10).to(0)
    end
  end

  describe "#loser" do
    subject { match.loser }

    let(:winner) { FactoryGirl.create :player }
    let(:loser) { FactoryGirl.create :player }

    context "when the away player has won" do
      let(:match) do
        FactoryGirl.create :complete_match,
                           home_player: loser,
                           away_player: winner,
                           victor: winner
      end

      it { is_expected.to eq loser }
    end

    context "when the home player has won" do
      let(:match) do
        FactoryGirl.create :complete_match,
                           home_player: winner,
                           away_player: loser,
                           victor: winner
      end

      it { is_expected.to eq loser }
    end
  end

  describe ".finalized" do
    let!(:ongoing_match) { FactoryGirl.create :match }
    let!(:finalized_match) { FactoryGirl.create :match, :finalized }

    subject { described_class.finalized }

    it "includes only finalized matches" do
      expect(subject).to match_array [finalized_match]
    end
  end

  describe ".ongoing" do
    let!(:ongoing_match) { FactoryGirl.create :match }
    let!(:finalized_match) { FactoryGirl.create :match, :finalized }

    subject { described_class.ongoing }

    it "includes only ongoing matches" do
      expect(subject).to match_array [ongoing_match]
    end
  end

  describe "#finalized?" do
    subject { match.finalized? }

    context "when finalized_at is nil" do
      let(:match) { FactoryGirl.create :match }

      it { is_expected.to eq false }
    end

    context "when finalized_at is not nil" do
      let(:match) { FactoryGirl.create :match, :finalized }

      it { is_expected.to eq true }
    end
  end

  describe "#finalize!" do
    subject { match.finalize! }

    let(:match) { FactoryGirl.create :match }

    it { is_expected.to eq true }

    it "marks the match as finalized" do
      expect { subject }.
        to change { match.reload.finalized? }.
        from(false).to(true)
    end
  end

  describe "player points" do
    let(:match) { FactoryGirl.create :match, :at_start }

    let(:home_point_1) do
      FactoryGirl.create :point, match: match, victor: match.home_player
    end
    let(:home_point_2) do
      FactoryGirl.create :point, match: match, victor: match.home_player
    end

    let(:away_point_1) do
      FactoryGirl.create :point, match: match, victor: match.away_player
    end

    describe "#home_points" do
      subject { match.home_points }
      it { is_expected.to match_array [home_point_1, home_point_2] }
    end

    describe "#away_points" do
      subject { match.away_points }
      it { is_expected.to eq [away_point_1] }
    end
  end

  describe "scores" do
    let(:match) do
      FactoryGirl.create :match,
                         home_score: 5,
                         away_score: 10
    end

    describe "#home_score" do
      subject { match.home_score }
      it { is_expected.to eq 5 }
    end

    describe "#away_score" do
      subject { match.away_score }
      it { is_expected.to eq 10 }
    end
  end

  describe "#first_service_by_away_player?" do
    subject { match.first_service_by_away_player? }

    let(:match) { FactoryGirl.build :match }

    context "when home player serves first" do
      before { match.first_service_by_home_player! }
      it { is_expected.to be false }
    end

    context "when away player serves first" do
      before { match.first_service_by_away_player! }
      it { is_expected.to be true }
    end
  end

  describe "#finished?" do
    subject { match.finished? }

    let(:match) do
      FactoryGirl.create :match,
                         home_score: home_score,
                         away_score: away_score
    end

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

  describe "#game_point" do
    subject { match.game_point }

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
    subject { match.home_player_service? }

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
    subject { match.away_player_service? }

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
    subject { match.leader }

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
    subject { match.trailer }

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
    subject { match.leading_score }

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
    subject { match.trailing_score }

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
    subject { match.score_differential }
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

  describe "#warmup?" do
    subject { match.warmup? }

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
    subject { match.warmup_seconds_left }

    before do
      require 'timecop'
      Timecop.freeze
    end
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
