require 'rails_helper'

RSpec.describe Api::ActivationsController, type: :controller do
  include_context "controller authorization"
  render_views

  describe "GET index" do
    subject { get :index, format: :json }
    before { ability.can :read, Player }

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
        { "name" => "Joe", "id" => player1.id, "active" => true },
        { "name" => "Ada", "id" => player2.id, "active" => false }
      ])
    end
  end

  describe "PUT activate" do
    subject { put :activate, id: player.id, format: :json }
    before do
      ability.can :read, Player
      ability.can :update, player
    end

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
    subject { put :deactivate, id: player.id, format: :json }
    before do
      ability.can :read, Player
      ability.can :update, player
    end

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
