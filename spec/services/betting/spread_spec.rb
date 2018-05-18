require 'rails_helper'

RSpec.describe Betting::Spread do
  let(:calculator) { described_class.new(home_player: adam, away_player: jared) }
  let(:adam) { FactoryGirl.create :player, name: "Adam" }
  let(:jared) { FactoryGirl.create :player, name: "Jared" }

  before do
    FactoryGirl.create :complete_match, home_player: adam, away_player: jared

    4.times do
      FactoryGirl.create :complete_match, home_player: jared, away_player: adam
      FactoryGirl.create :complete_match, home_player: adam, away_player: jared
    end
  end

  context "when the players have played less than ten games" do
    it "doesn't calculate the spread" do
      expect(calculator.spread).to be_nil
      expect(calculator.favourite).to be_nil
    end
  end

  context "when the players have played at least ten games" do
    context "when Adam is the favourite (lol unlikely)" do
      before do
        FactoryGirl.create :complete_match, home_player: adam, away_player: jared, away_score: 9
      end

      it "calculates the spread" do
        expect(calculator.spread).to eq -0.5
        expect(calculator.favourite).to eq adam
      end
    end

    context "when Jared is the favourite" do
      before do
        FactoryGirl.create :complete_match, home_player: jared, away_player: adam, away_score: 0
      end

      it "calculates the spread" do
        expect(calculator.spread).to eq -0.5
        expect(calculator.favourite).to eq jared
      end
    end
  end
end
