require 'rails_helper'

RSpec.describe EloAdjustment do
  let(:adjustment) do
    described_class.new(
      victor: victor,
      loser: loser,
      match: match
    )
  end

  let(:match) { create :complete_match }
  let(:victor) { match.victor }
  let(:loser) { match.loser }

  describe "#adjust!" do
    subject { adjustment.adjust! }

    context "when the players have the default rating" do
      it "increases the victor's rating" do
        subject
        expect(victor.reload.elo).to eq 1020
      end

      it "decreases the loser's rating" do
        subject
        expect(loser.reload.elo).to eq 980
      end
    end
  end
end
