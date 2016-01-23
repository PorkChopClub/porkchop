require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  describe "GET show" do
    let!(:match) { FactoryGirl.create :complete_match }

    subject { get :show, id: match.to_param }

    it { is_expected.to have_http_status :ok }

    it { is_expected.to render_template :show }

    it "assigns the match as @match" do
      subject
      expect(assigns(:match)).to eq match
    end
  end
end
