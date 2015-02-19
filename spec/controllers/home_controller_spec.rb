require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    subject { get :index }

    let!(:recent_match) { FactoryGirl.create :complete_match }
    let!(:ongoing_match) { FactoryGirl.create :match }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :index }

    it "assigns the recent matches as @recent_matches" do
      subject
      expect(assigns(:recent_matches)).to match_array [recent_match]
    end
  end
end
