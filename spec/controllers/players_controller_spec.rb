require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  describe "GET index" do
    subject { get :index }

    let(:players) { FactoryGirl.create_list :player, 3 }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :index }

    it "assigns all players as @players" do
      subject
      expect(assigns(:players)).to eq players.sort_by(&:name)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: player.to_param } }

    let(:player) { FactoryGirl.create :player }
    let(:stats) { instance_double Stats::Personal }

    before do
      expect(Stats::Personal).
        to receive(:new).
        with(player).
        and_return(stats)
    end

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :show }

    it "assigns the player as @player" do
      subject
      expect(assigns(:player)).to eq player
    end

    it "assigns the personal stats as @stats" do
      subject
      expect(assigns(:stats)).to eq stats
    end
  end
end
