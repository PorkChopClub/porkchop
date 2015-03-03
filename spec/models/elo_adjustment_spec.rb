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
end
