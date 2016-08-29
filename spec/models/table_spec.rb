require 'rails_helper'

RSpec.describe Table, type: :model do
  it { is_expected.to have_many :matches }
  it { is_expected.to validate_presence_of :name }

  describe "#ongoing_match" do
    subject { table.ongoing_match }

    let(:table) { create :table }

    context "when there is no ongoing match" do
      it { is_expected.to be_nil }
    end

    context "when there is an ongoing match" do
      let!(:other_table_match) { create :new_match }
      let!(:finished_match) { create :complete_match, table: table }
      let!(:ongoing_match) { create :new_match, table: table }
      it { is_expected.to eq ongoing_match }
    end
  end
end
