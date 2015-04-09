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
        { "name" => "Joe", "active" => true },
        { "name" => "Ada", "active" => false }
      ])
    end
  end
end
