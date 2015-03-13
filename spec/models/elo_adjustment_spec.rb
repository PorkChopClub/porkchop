require 'rails_helper'

RSpec.describe EloAdjustment do
  let(:adjustment) do
    described_class.new(
      victor: victor,
      loser: loser
    )
  end

  describe "#adjust!" do
    subject { adjustment.adjust! }

    context "when the players have the default rating" do
      let(:victor) { FactoryGirl.create :player }
      let(:loser) { FactoryGirl.create :player }

      it "increases the victor's rating" do
        subject
        expect(victor.reload.elo).to eq 1016
      end

      it "decreases the loser's rating" do
        subject
        expect(loser.reload.elo).to eq 984
      end
    end

    context "when the players have very different ratings" do
      let(:victor) { FactoryGirl.create :player, elo: 700 }
      let(:loser) { FactoryGirl.create :player, elo: 1200 }

      it "increases the victor's rating" do
        subject
        expect(victor.reload.elo).to eq 730
      end

      it "decreases the loser's rating" do
        subject
        expect(loser.reload.elo).to eq 1169
      end
    end
  end
end
