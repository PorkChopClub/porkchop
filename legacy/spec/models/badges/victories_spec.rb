require 'rails_helper'

RSpec.describe Badger, ":victories", type: :model do
  let(:badge) { Badger.registry[:victories] }

  describe ".ranks" do
    subject { badge.ranks }
    it { is_expected.to eq [1, 5, 10, 25, 50, 100, 250, 500, 1000] }
  end

  describe ".earned?" do
    subject { Badger.earned?(:victories, player: player) }
    context "when achivement doesn't have a player" do
      let(:player) { nil }
      it { is_expected.to be false }
    end
    context "when achievement has a player" do
      let(:player) { FactoryGirl.create :player }
      context "and they have at least 1 victory" do
        let(:match) { instance_double Match }
        before do
          allow(player).to receive(:victories).and_return([match])
        end
        it { is_expected.to be true }
      end
      context "and they have never won a game" do
        it { is_expected.to be false }
      end
    end
  end

  describe ".determine_rank" do
    subject { Badger.determine_rank(:victories, player: player) }
    context "when achivement doesn't have a player" do
      let(:player) { nil }
      it { is_expected.to eq 0 }
    end
    context "when achievement has a player" do
      let(:player) { FactoryGirl.create :player }
      context "and they have 1 win" do
        let(:match) { instance_double Match }
        before { allow(player).to receive(:victories).and_return([match]) }
        it { is_expected.to eq 0 }
      end
      context "and they have 25 wins" do
        let(:match) { instance_double Match }
        before { allow(player).to receive(:victories).and_return([match] * 25) }
        it { is_expected.to eq 3 }
      end
    end
  end
end
