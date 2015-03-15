require 'rails_helper'

RSpec.describe Badger::Configuration, type: :model do
  let(:config) { Badger::Configuration.new }

  describe "#new" do
    subject { config }
    it "creates a registry hash" do
      expect(config.registry).to eq Hash.new
    end
  end

  describe "#varieties" do
    subject { config.varieties }
    before { config.registry[:best] = "Adam" }
    it { is_expected.to eq ["best"] }
  end
end
