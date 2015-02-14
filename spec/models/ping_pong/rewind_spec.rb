require 'rails_helper'

RSpec.describe PingPong::Rewind do
  let(:rewind) { described_class.new(match) }

  describe "#rewind!" do
    subject { rewind.rewind! }

    shared_examples "failure" do
      it "doesn't delete any points" do
        expect{subject}.not_to change{Point.count}
      end

      it { is_expected.to eq false }
    end

    context "when the match is finalized" do
      let!(:match) { FactoryGirl.create :complete_match }
      it_behaves_like "failure"
    end

    context "when the match has no points" do
      let!(:match) { FactoryGirl.create :match, :at_start }
      it_behaves_like "failure"
    end

    context "when the match can be rewind" do
      let!(:match) { FactoryGirl.create :match, home_score: 10, away_score: 6 }
      let(:point) { FactoryGirl.create :point, match: match, victor: match.away_player }

      it { is_expected.to eq true }

      it "deletes the most recent point" do
        expect{subject}.
          to change{Point.exists? point.id}.
          from(true).to(false)
      end
    end
  end
end
