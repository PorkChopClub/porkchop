require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability do
  subject { Ability.new(player) }

  context "without a player" do
    let(:player) { nil }

    it { is_expected.to be_able_to(:read, :all) }
    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
    it { is_expected.not_to be_able_to(:destroy, :all) }
  end

  context "when the player isn't an admin" do
    let(:player) { create :player }

    it { is_expected.to be_able_to(:read, :all) }
    it { is_expected.to be_able_to(:update, player) }
    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
    it { is_expected.not_to be_able_to(:destroy, :all) }
  end

  context "when the player is an admin" do
    let(:player) { create :admin_player }

    it { is_expected.to be_able_to(:read, :all) }
    it { is_expected.to be_able_to(:create, :all) }
    it { is_expected.to be_able_to(:update, :all) }
    it { is_expected.to be_able_to(:destroy, :all) }
  end
end
