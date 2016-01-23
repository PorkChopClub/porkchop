require 'rails_helper'

RSpec.describe Api::PlayersController, type: :controller do
  render_views

  describe "GET index" do
    let!(:player) { FactoryGirl.create :player, name: "Candice Bergen" }

    subject { get :index, format: :json }

    specify { expect(subject.status).to eq 200 }

    it "returns an array of the players" do
      expect(JSON.parse(subject.body)['players']).to eq [{
        "name" => "Candice Bergen",
        "id" => player.id
      }]
    end
  end
end
