require 'rails_helper'

RSpec.describe Api::PlayersController, type: :controller do
  render_views
  include_context "controller authorization"

  describe "GET index" do
    let!(:player) { FactoryGirl.create :player }

    subject { get :index, format: :json }
    before { ability.can :read, Player }

    specify { expect(subject.status).to eq 200 }

    it "returns an array of the players" do
      expect(JSON.parse(subject.body)['players']).to eq [{
        "name" => "Candice Bergen",
        "id" => player.id
      }]
    end
  end
end
