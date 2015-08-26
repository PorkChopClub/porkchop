require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  subject { described_class.new user }

  shared_examples "public access" do
    it { is_expected.to be_able_to :read, User.new }
    it { is_expected.to be_able_to :read, Point.new }
    it { is_expected.to be_able_to :read, Player.new }
    it { is_expected.to be_able_to :read, Match.new }
  end

  shared_examples "read-only access" do
    it { is_expected.not_to be_able_to :update, User.new }
    it { is_expected.not_to be_able_to :update, Point.new }
    it { is_expected.not_to be_able_to :update, Player.new }
    it { is_expected.not_to be_able_to :update, Match.new }
  end

  describe "nobody's permissions" do
    let(:user) { nil }

    include_examples "public access"
    include_examples "read-only access"
  end

  describe "regular user permissions" do
    let(:user) { FactoryGirl.create :user }

    include_examples "public access"
    include_examples "read-only access"

    it { is_expected.to be_able_to :update, user }
  end

  describe "admin user permissions" do
    let(:user) { FactoryGirl.create :admin_user }

    include_examples "public access"

    it { is_expected.to be_able_to :update, User.new }
    it { is_expected.to be_able_to :update, Point.new }
    it { is_expected.to be_able_to :update, Player.new }
    it { is_expected.to be_able_to :update, Match.new }
  end
end
