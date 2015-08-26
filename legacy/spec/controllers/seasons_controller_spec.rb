require 'rails_helper'

RSpec.describe SeasonsController, type: :controller do
  include_context "controller authorization"

  describe "GET show" do
    let!(:season) { FactoryGirl.create :season }

    subject { get :show, id: season.to_param }
    before { ability.can :read, season }

    specify { expect(subject.status).to eq 200 }

    it { is_expected.to render_template :show }

    it "assigns the season as @season" do
      subject
      expect(assigns(:season)).to eq season
    end
  end
end
