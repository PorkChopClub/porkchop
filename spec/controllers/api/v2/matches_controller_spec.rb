require 'rails_helper'

RSpec.describe Api::V2::MatchesController, type: :controller do
  describe "GET #ongoing" do
    subject { get :ongoing, params: { table_id: table_id } }

    context "when the table exists" do
      let(:table_id) { table.id }
      let(:table) { create :table }

      context "when there is an ongoing match" do
        let!(:ongoing_match) { create :match, table: table }

        it { is_expected.to have_http_status :ok }
      end

      context "when there is not an ongoing match" do
        let!(:finished_match) { create :complete_match, table: table }

        it { is_expected.to have_http_status :not_found }
      end
    end

    context "when the table doesn't exist" do
      let(:table_id) { 12_345 }
      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "POST #setup" do
    subject { post :setup, params: { table_id: table_id } }

    before { sign_in create(:admin_player) }

    context "when the table exists" do
      let(:table_id) { table.id }
      let(:table) { create :default_table }

      context "when there is an ongoing match" do
        let!(:ongoing_match) { create :match, table: table }

        context "when not enough players want to play" do
          it "destroys the current match" do
            expect(ongoing_match).to be_persisted
            subject
            expect { ongoing_match.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it { is_expected.to have_http_status :unprocessable_entity }
        end

        context "when enough players want to play" do
          before do
            2.times { create :active_player }
          end

          it "destroys the current match and creates a new one" do
            expect(ongoing_match).to be_persisted
            expect { subject }.not_to change { Match.count }.from 1
            expect { ongoing_match.reload }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it { is_expected.to have_http_status :created }
        end
      end

      context "when there is not an ongoing match" do
        context "when not enough players want to play" do
          it "doesn't create any matches" do
            expect { subject }.not_to change { Match.count }.from 0
          end

          it { is_expected.to have_http_status :unprocessable_entity }
        end

        context "when enough players want to play" do
          before do
            2.times { create :active_player }
          end

          it "creates a new match" do
            expect { subject }.to change { Match.count }.from(0).to(1)
          end

          it { is_expected.to have_http_status :created }
        end
      end
    end

    context "when the table doesn't exist" do
      let(:table_id) { 12_345 }
      it { is_expected.to have_http_status :not_found }
    end
  end
end
