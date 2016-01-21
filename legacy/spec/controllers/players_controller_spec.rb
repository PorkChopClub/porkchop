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
    subject { get :show, id: player.to_param }

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

  describe "GET edit" do
    subject do
      get :edit,
          { id: player.to_param },
          { write_access: true }
    end

    let(:player) { FactoryGirl.create :player }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :edit }

    it "assigns the player as @player" do
      subject
      expect(assigns(:player)).to eq player
    end
  end

  describe "PATCH update" do
    subject do
      patch :update,
            { id: player.to_param, player: player_params },
            { write_access: true }
    end

    let(:player) { FactoryGirl.create :player, nickname: "Candice Bergen" }

    context "with valid params" do
      let(:player_params) { { "nickname" => "Bandice Cergen" } }

      it { is_expected.to redirect_to player }

      it "updates the player" do
        expect { subject }.
          to change { player.reload.nickname }.
          from("Candice Bergen").to("Bandice Cergen")
      end
    end
  end
end
