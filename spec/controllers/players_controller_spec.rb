require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  describe "GET show" do
    subject { get :show, id: player.to_param }

    let(:player) { FactoryGirl.create :player }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :show }

    it "assigns the player as @player" do
      subject
      expect(assigns(:player)).to eq player
    end
  end
end