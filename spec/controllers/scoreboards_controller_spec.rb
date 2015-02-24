require 'rails_helper'

RSpec.describe ScoreboardsController, type: :controller do
  include_context "controller authorization"

  describe "GET show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status :success
    end
  end

  describe "GET edit" do
    subject { get :edit }
    before { ability.can :edit, match }

    context "when there is an ongoing match" do
      let(:match) { FactoryGirl.create :match }
      it { is_expected.to have_http_status :success }
    end

    context "when there is no ongoing match" do
      let(:match) { FactoryGirl.create :complete_match }
      it { is_expected.to redirect_to new_match_path }
    end
  end
end
