require "rails_helper"

RSpec.describe Stats::StreakAdjustment do
  let(:adjustment) do
    described_class.new(
      player: player,
      match_result: match_result
    )
  end

  let!(:streak) { FactoryGirl.create :streak, player: player, streak_length: 3 }
  let(:player) { FactoryGirl.create :player }
  let(:match_result) { "W" }

  describe "#adjust!" do
    subject { adjustment.adjust! }

    context "when a player is already on a winning streak" do
      context "and they win another game" do
        it "increases their streak by 1" do
          expect{ subject }.to change{
            player.current_streak.streak_length }.by(1)
        end
      end

      context "and they lose their next game" do
        let(:match_result) { "L" }

        it "ends their current streak" do
          subject
          expect(streak.reload.finished_at).to_not be_nil
        end

        it "starts a new streak" do
          subject
          expect(player.current_streak.streak_length).to eq 1
        end
      end
    end
  end
end
