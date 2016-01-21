require 'rails_helper'

RSpec.describe PlayerMatchesController, type: :controller do
  describe "GET index" do
    subject { get :index, player_id: player.to_param }

    let(:player) { FactoryGirl.create :player }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :index }

    it "assigns the player as @player" do
      subject
      expect(assigns(:player)).to eq player
    end
  end
end
