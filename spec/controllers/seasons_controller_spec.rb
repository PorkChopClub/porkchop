require 'rails_helper'

RSpec.describe SeasonsController, type: :controller do
  describe "GET show" do
    let!(:season) { FactoryGirl.create :season }

    subject { get :show, params: { id: season.to_param } }

    specify { expect(subject.status).to eq 200 }

    it { is_expected.to render_template :show }

    it "assigns the season as @season" do
      subject
      expect(assigns(:season)).to eq season
    end
  end
end
