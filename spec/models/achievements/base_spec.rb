require 'rails_helper'

RSpec.describe Achievements::Base, type: :model do
  let(:base) { Achievements::Base.new }

  describe "#condition" do
    let(:dummy_proc) { lambda{} }
    before { base.condition &dummy_proc }
    it "stores the condition" do
      expect(base.condition_proc).to eq dummy_proc
    end
  end
end
