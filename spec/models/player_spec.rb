require 'rails_helper'

RSpec.describe Player, type: :model do
  it { is_expected.to have_many :points }
  it { is_expected.to have_many :victories }
  it { is_expected.to have_many :elo_ratings }
  it { is_expected.to have_many :achievements }
  it { is_expected.to have_many :season_memberships }
  it { is_expected.to have_many :seasons }
  it { is_expected.to have_many :streaks }

  let(:player) { FactoryGirl.create :player }

  it "is invalid without a name" do
    expect(described_class.new.valid?).to be false
  end

  it "is valid with a name" do
    expect(described_class.new(name: 'Jeff').valid?).to be true
  end

  describe "#matches" do
    subject { player.matches }

    let!(:away_match) do
      FactoryGirl.create :match,
                         away_player: player
    end

    let!(:home_match) do
      FactoryGirl.create :match,
                         home_player: player
    end

    it "includes both home and away matches" do
      expect(subject).to match_array [home_match, away_match]
    end
  end

  describe "#losses" do
    subject { player.losses }

    let!(:win) do
      FactoryGirl.create :complete_match,
                         away_player: player,
                         victor: player
    end

    let!(:loss) do
      FactoryGirl.create :complete_match,
                         away_player: player
    end

    let!(:incomplete_match) do
      FactoryGirl.create :match,
                         home_player: player
    end

    specify { expect(subject).to match_array [loss] }
  end

  describe "#matches_against" do
    subject { player.matches_against opponent }
    let(:opponent) { FactoryGirl.create :player }

    let!(:incomplete_match) do
      FactoryGirl.create :match,
                         home_player: opponent,
                         away_player: player
    end

    let!(:away) do
      FactoryGirl.create :complete_match,
                         home_player: opponent,
                         away_player: player
    end

    let!(:home) do
      FactoryGirl.create :complete_match,
                         home_player: player,
                         away_player: opponent
    end

    let!(:other) do
      FactoryGirl.create :complete_match
    end

    it { is_expected.to match_array [away, home] }
  end

  describe "#elo=" do
    let(:player) { FactoryGirl.create :player, elo: 666 }

    context "without saving" do
      it "does not change the player's rating" do
        expect do
          player.elo = 1000
        end.not_to change { player.reload.elo }
      end
    end

    context "without saving" do
      it "does not change the player's rating" do
        expect do
          player.elo = 1000
          player.save
        end.to change { player.reload.elo }.from(666).to(1000)
      end
    end
  end

  describe "#elo" do
    subject { player.elo }

    context "when the player has no recorded ratings" do
      it { is_expected.to eq 1000 }
    end

    context "when the player has recorded ratings" do
      let!(:old_rating) do
        FactoryGirl.create :elo_rating,
                           player: player,
                           rating: 10,
                           created_at: 1.minute.ago
      end

      let!(:newest_rating) do
        FactoryGirl.create :elo_rating,
                           player: player,
                           rating: 1200
      end

      it "returns the rating of the most recent one" do
        expect(subject).to eq 1200
      end
    end
  end

  describe "#unearned_achievements" do
    subject { player.unearned_achievements }
    it "contains a victories achievement" do
      expect(subject.first.variety).to eq "victories"
    end
  end

  describe "#stats" do
    subject { player.stats }
    it { should be_a Stats::Personal }
  end
end
