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
      it { is_expected.to eq [home_point_1, home_point_2] }
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
end
