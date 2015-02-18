require 'rails_helper'

RSpec.describe Match, type: :model do
  it { is_expected.to belong_to :home_player }
  it { is_expected.to belong_to :away_player }
  it { is_expected.to belong_to :victor }

  it { is_expected.to validate_presence_of :home_player }
  it { is_expected.to validate_presence_of :away_player }

  describe "#destroy" do
    let!(:match) { FactoryGirl.create :match, home_score: 10, away_score: 0 }

    subject { match.destroy }

    it "destroys its points" do
      expect{subject}.
        to change{Point.count}.
        from(10).to(0)
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

  describe "#finished?" do
    let(:match) {
      FactoryGirl.create :match,
        home_score: home_score,
        away_score: away_score
    }

    subject { match.finished? }

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

    context "when the match isn't finished" do
      let(:match) { FactoryGirl.create :match }

      it { is_expected.to eq false }

      it "doesn't mark the match as finalized" do
        expect{subject}.not_to change{match.reload.finalized_at}
      end
    end

    context "when the match is finished" do
      context "when the match is not finalized" do
        let(:match) { FactoryGirl.create :match, :finished }

        it { is_expected.to eq true }

        it "marks the match as finalized" do
          expect{subject}.
            to change{match.reload.finalized?}.
            from(false).to(true)
        end
      end

      context "when the match is already finalized" do
        let(:match) { FactoryGirl.create :match, :finished, :finalized }

        it { is_expected.to eq false }

        it "doesn't change the finalized_at timestamp" do
          expect{subject}.not_to change{match.reload.finalized_at}
        end
      end
    end
  end

  describe "player points" do
    let(:match) { FactoryGirl.create :match, :at_start }

    let(:home_point_1) {
      FactoryGirl.create :point, match: match, victor: match.home_player
    }
    let(:home_point_2) {
      FactoryGirl.create :point, match: match, victor: match.home_player
    }

    let(:away_point_1) {
      FactoryGirl.create :point, match: match, victor: match.away_player
    }

    describe "#home_points" do
      subject { match.home_points }
      it { is_expected.to eq [home_point_1, home_point_2] }
    end

    describe "#away_points" do
      subject { match.away_points }
      it { is_expected.to eq [away_point_1] }
    end
  end

  describe "#leader" do
    subject { match.leader }

    let(:home_player) { FactoryGirl.create :player }
    let(:away_player) { FactoryGirl.create :player }

    context "when the game is tied" do
      let(:match) {
        FactoryGirl.create :match,
          home_player: home_player,
          away_player: away_player,
          home_score: 5,
          away_score: 5
      }
      it { is_expected.to eq nil }
    end

    context "when the home player is leading" do
      let(:match) {
        FactoryGirl.create :match,
          home_player: home_player,
          away_player: away_player,
          home_score: 6,
          away_score: 5
      }
      it { is_expected.to eq home_player }
    end

    context "when the away player is leading" do
      let(:match) {
        FactoryGirl.create :match,
          home_player: home_player,
          away_player: away_player,
          home_score: 5,
          away_score: 6
      }
      it { is_expected.to eq away_player }
    end
  end

  describe "scores" do
    let(:match) {
      FactoryGirl.create :match,
        home_score: 5,
        away_score: 10
    }

    describe "#home_score" do
      subject { match.home_score }
      it { is_expected.to eq 5 }
    end

    describe "#away_score" do
      subject { match.away_score }
      it { is_expected.to eq 10 }
    end
  end
end
