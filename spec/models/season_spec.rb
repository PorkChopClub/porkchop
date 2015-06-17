require 'rails_helper'

RSpec.describe Season, type: :model do
  it { is_expected.to validate_numericality_of(:games_per_matchup).is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:games_per_matchup).even }

  it { is_expected.to have_many(:season_memberships) }
  it { is_expected.to have_many(:players) }

  it { is_expected.to have_many(:season_matches) }
  it { is_expected.to have_many(:matches) }

  describe "#eligible?" do
    let(:luke) do
      FactoryGirl.create(
        :player,
        active: true,
        name: "Luke Skywalker"
      )
    end
    let(:vader) do
      FactoryGirl.create(
        :player,
        active: true,
        name: "Darth Vader"
      )
    end
    let(:leia) do
      FactoryGirl.create(
        :player,
        active: true,
        name: "Leia Organa"
      )
    end
    let(:matchup) { Matchup.new(luke, vader) }
    let(:season) { FactoryGirl.create(:season) }

    before { season.players = [luke, vader] }

    subject { season.eligible?(matchup) }

    context "when all matchups have already been played" do
      before do
        season.matches = [
          FactoryGirl.create(:complete_match, home_player: luke, away_player: vader),
          FactoryGirl.create(:complete_match, home_player: vader, away_player: luke)
        ]
      end
      it { is_expected.to be_falsy }
    end

    context "when matchup has not been played yet" do
      it { is_expected.to be_truthy }
    end

    context "when matchup has players not part of the season" do
      let(:matchup) { Matchup.new(luke, leia) }
      it { is_expected.to be_falsy }
    end
  end

  describe "#finalize!" do
    subject { season.finalize! }

    context "when the season is not finalized" do
      let(:season) { FactoryGirl.create :season }

      it "touches the finalized_at" do
        expect(season.reload.finalized_at).to eq nil
        subject
        expect(season.reload.finalized_at).
          to be_within(1.second).of(Time.zone.now)
      end
    end

    context "when the season is already finalized" do
      let(:season) { FactoryGirl.create :season, :finalized }

      it "does not change the finalized_at" do
        expect { subject }.not_to change { season.reload.finalized_at }
      end
    end
  end
end
