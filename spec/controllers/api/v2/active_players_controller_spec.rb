require 'rails_helper'

RSpec.describe Api::V2::ActivePlayersController do
  describe "GET #index" do
    subject { get :index, params: { table_id: table_id } }

    context "when the table exists" do
      let(:table_id) { table.to_param }
      let(:table) { create :table }
      let!(:active_player_one) { create :active_player }
      let!(:active_player_two) { create :active_player }
      let!(:inactive_player) { create :player }

      it { is_expected.to have_http_status :ok }
    end

    context "when the table doesn't exist" do
      let(:table_id) { "potato" }

      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "POST #create" do
    subject do
      post :create,
           params: { table_id: table_id, active_player: active_player_params }
    end

    let(:active_player_params) { { id: player_id } }

    before { sign_in create(:admin_player) }

    context "when the table exists" do
      let(:table_id) { table.to_param }
      let(:table) { create :default_table }

      context "when the player exists" do
        let(:player_id) { player.id }
        let(:player) { create :player }

        it { is_expected.to have_http_status :ok }

        it "activates the player" do
          expect { subject }.to change { player.reload.active? }.from(false).to(true)
        end
      end

      context "when the player doesn't exist" do
        let(:player_id) { "space-dog-laika" }
        it { is_expected.to have_http_status :not_found }
      end
    end

    context "when the table doesn't exist" do
      let(:table_id) { "potato" }
      let(:player_id) { 1 }

      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "DELETE #destroy" do
    subject do
      delete :destroy,
             params: { table_id: table_id, id: player_id }
    end

    before { sign_in create(:admin_player) }

    context "when the table exists" do
      let(:table_id) { table.to_param }
      let(:table) { create :default_table }

      context "when the player exists" do
        let(:player_id) { player.id }
        let(:player) { create :player, active: true }

        it { is_expected.to have_http_status :ok }

        it "deactivates the player" do
          expect { subject }.to change { player.reload.active? }.from(true).to(false)
        end
      end

      context "when the player doesn't exist" do
        let(:player_id) { "space-dog-laika" }
        it { is_expected.to have_http_status :not_found }
      end
    end

    context "when the table doesn't exist" do
      let(:table_id) { "potato" }
      let(:player_id) { 1 }

      it { is_expected.to have_http_status :not_found }
    end
  end
end
