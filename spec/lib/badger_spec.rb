require 'rails_helper'

RSpec.describe Badger, type: :model do
  Badger.define do
    badge :first do
      condition do |player|
        player.name == "Olivia"
      end
    end
  end

  describe ".varieties" do
    subject { Badger.varieties }
    it { is_expected.to include "first" }
  end

  describe "#earned?" do
    subject { Badger.earned?(:first, player: player) }

    context "when there's no player" do
      let(:player) { nil }
      it { is_expected.to be false }
    end

    context "when player is set" do
      context "and the condition is satisfied" do
        let(:player) { FactoryGirl.build :player, name: "Olivia" }
        it { is_expected.to be true }
      end
      context "and the condition is not satisfied" do
        let(:player) { FactoryGirl.build :player, name: "Fauxlivia" }
        it { is_expected.to be false }
      end
    end
  end
end
