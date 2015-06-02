require 'rails_helper'

RSpec.describe EloAdjustment do
  let(:adjustment) do
    described_class.new(
      victor: victor,
      loser: loser,
      matches: Match.all
    )
  end

  let(:victor) { FactoryGirl.create :player }
  let(:loser) { FactoryGirl.create :player }

  describe "#adjust!" do
    subject { adjustment.adjust! }

    context "when the players have the default rating" do
      it "increases the victor's rating" do
        subject
        expect(victor.reload.elo).to eq 1012
      end

      it "decreases the loser's rating" do
        subject
        expect(loser.reload.elo).to eq 987
      end
    end

    context "when the players have very different ratings" do
      let(:victor) { FactoryGirl.create :player, elo: 700 }
      let(:loser) { FactoryGirl.create :player, elo: 1200 }

      it "increases the victor's rating" do
        subject
        expect(victor.reload.elo).to eq 723
      end

      it "decreases the loser's rating" do
        subject
        expect(loser.reload.elo).to eq 1185
      end
    end
  end

  describe "#victor_elo_change" do
    subject { adjustment.victor_elo_change }

    it "returns the change in elo for the victor" do
      subject
      expect(subject).to eq 12
    end
  end

  describe "#loser_elo_change" do
    subject { adjustment.loser_elo_change }

    it "returns the change in elo for the loser" do
      subject
      expect(subject).to eq -13
    end
  end
end
