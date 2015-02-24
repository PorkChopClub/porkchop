require 'rails_helper'

RSpec.describe PlayersController, type: :controller do
  include_context "controller authorization"

  describe "GET index" do
    subject { get :index }
    before { ability.can :read, Player }

    let(:players) { FactoryGirl.create_list :player, 3 }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :index }

    it "assigns all players as @players" do
      subject
      expect(assigns(:players)).to eq players
    end
  end

  describe "GET show" do
    subject { get :show, id: player.to_param }
    before { ability.can :read, player }

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
    subject { get :edit, id: player.to_param }

    let(:player) { FactoryGirl.create :player }
    before { ability.can :update, player }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :edit }

    it "assigns the player as @player" do
      subject
      expect(assigns(:player)).to eq player
    end
  end

  describe "PATCH update" do
    subject { patch :update, id: player.to_param, player: player_params }
    before { ability.can :update, player }

    let(:player) { FactoryGirl.create :player, name: "Candice Bergen" }

    context "with valid params" do
      let(:player_params) { {"name" => "Bandice Cergen"} }

      it { is_expected.to redirect_to player }

      it "updates the player" do
        expect{subject}.
          to change{player.reload.name}.
          from("Candice Bergen").to("Bandice Cergen")
      end
    end

    context "with invalid params" do
      let(:player_params) { {"name" => nil} }

      it "doesn't update the player" do
        expect{subject}.not_to change{player.reload}
      end

      it { is_expected.to render_template :edit }

      specify { expect(subject.status).to eq 200 }
    end
  end

end
