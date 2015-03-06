require 'rails_helper'

RSpec.describe PingPong::Comment do
  let(:comment) { described_class.new match }
  let(:match) { double "match" }

  describe "#priority" do
    subject { comment.priority }
    it { is_expected.to eq 0 }
  end

  describe "#available?" do
    subject { comment.available? }
    it { is_expected.to eq true }
  end

  describe "#message" do
    subject { comment.message }
    it "throws an error" do
      expect{subject}.
        to raise_error NotImplementedError
    end
  end
end
