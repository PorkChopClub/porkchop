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

  describe "POST #create"
  describe "DELETE #destroy"
end
