require 'badger/base'
require 'spec_helper'

RSpec.describe Badger::Base, type: :model do
  let(:base) { Badger::Base.new }

  describe "#ranks" do
    let(:ranks) { [1, 2, 3, 4] }
    before { base.ranks ranks }
    it "stores the ranks" do
      expect(base.ranks).to eq ranks
    end
  end

  describe "#condition" do
    let(:dummy_proc) { lambda{} }
    before { base.condition &dummy_proc }
    it "stores the condition" do
      expect(base.condition_proc).to eq dummy_proc
    end
  end

  describe "#calculate_rank" do
    let(:dummy_proc) { lambda{} }
    before { base.calculate_rank &dummy_proc }
    it "stores the rank calculator" do
      expect(base.rank_proc).to eq dummy_proc
    end
  end
end
