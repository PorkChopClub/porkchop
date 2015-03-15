require 'rails_helper'

RSpec.describe Achievements::Dsl, type: :model do
  class DummyClass
    include Achievements::Dsl

    attr_accessor :player, :variety

    achievements do
      achievement :first do
        condition do |player|
          player == "Olivia"
        end
      end
    end
  end

  describe ".varieties" do
    subject { DummyClass.varieties }
    it { is_expected.to include "first" }
  end

  describe "#achieved?" do
    let(:dummy_class) { DummyClass.new }
    before { dummy_class.variety = :first }

    subject { dummy_class.achieved? }

    context "when there's no player" do
      it { is_expected.to be false }
    end

    context "when player is set" do
      before { dummy_class.player = player }
      context "and the condition is satisfied" do
        let(:player) { "Olivia" }
        it { is_expected.to be true }
      end
      context "and the condition is not satisfied" do
        let(:player) { "Fauxlivia" }
        it { is_expected.to be false }
      end
    end
  end
end
