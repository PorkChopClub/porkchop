require 'rails_helper'

RSpec.describe Api::ActivationsController, type: :controller do
  render_views

  describe "GET index" do
    subject { get :index, format: :json }

    let!(:player1) do
      FactoryGirl.create :player, name: "Joe", active: true
    end
    let!(:player2) do
      FactoryGirl.create :player, name: "Ada", active: false
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }

    it "renders the player names and activations" do
      expect(JSON.parse(subject.body)).to eq("players" => [
                                               { "name" => "Ada", "id" => player2.id, "active" => false },
                                               { "name" => "Joe", "id" => player1.id, "active" => true }
                                             ])
    end
  end

  describe "PUT activate" do
    subject do
      put :activate,
          params: { id: player.id, format: :json },
          session: { write_access: true }
    end

    before { sign_in create(:admin_player) }

    let(:player) do
      FactoryGirl.create :player, active: false
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }

    it "activates the player" do
      expect { subject }.
        to change { player.reload.active }.
        from(false).to(true)
    end
  end

  describe "PUT deactivate" do
    subject do
      put :deactivate,
          params: { id: player.id, format: :json },
          session: { write_access: true }
    end

    before { sign_in create(:admin_player) }

    let(:player) do
      FactoryGirl.create :player, active: true
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }

    it "activates the player" do
      expect { subject }.
        to change { player.reload.active }.
        from(true).to(false)
    end
  end
end
