require 'rails_helper'

RSpec.describe Api::V2::MatchesController, type: :controller do
  describe "GET #ongoing" do
    subject { get :ongoing, params: { table_id: table_id } }

    context "when the table exists" do
      let(:table_id) { table.id }
      let(:table) { create :table }

      context "when there is an ongoing match" do
        let!(:ongoing_match) { create :match, home_score: 2, away_score: 5, table: table }
        let!(:finished_match) { create :complete_match, table: table }

        it { is_expected.to have_http_status :ok }

        it "assigns the match as @match" do
          subject
          expect(assigns(:match)).to eq ongoing_match
        end
      end

      context "when there is not an ongoing match" do
        let!(:finished_match) { create :complete_match, table: table }

        it { is_expected.to have_http_status :ok }

        it "assigns @match as nil" do
          subject
          expect(assigns(:match)).to be_nil
        end
      end
    end

    context "when the table doesn't exist" do
      let(:table_id) { 12_345 }

      it "should raise an error" do
        expect { subject }.
          to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
