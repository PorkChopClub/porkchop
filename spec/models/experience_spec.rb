require 'rails_helper'

RSpec.describe Experience do
  describe "#xp" do
    subject(:xp) { experience.xp }

    let(:experience) { create :experience, reason: reason }

    context "when the reason is complete_match" do
      let(:reason) { :completed_match }

      it { is_expected.to eq 100 }
    end

    context "when the reason is won_match" do
      let(:reason) { :won_match }

      it { is_expected.to eq 35 }
    end
  end
end
