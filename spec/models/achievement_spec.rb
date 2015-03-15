require 'rails_helper'

RSpec.describe Achievement, type: :model do
  it { is_expected.to belong_to :player }

  describe ".unearned" do
    let(:player) { FactoryGirl.create :player }
    subject { Achievement.unearned player }
    it "contains a victories achievement" do
      expect(subject.first.variety).to eq "victories"
    end
  end

  describe "#display_name" do
    let(:achievement) { FactoryGirl.build :achievement }
    subject { achievement.display_name }
    it { is_expected.to eq "Recruit" }
  end
end
