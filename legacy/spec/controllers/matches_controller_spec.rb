require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  include_context "controller authorization"

  describe "GET show" do
    let!(:match) { FactoryGirl.create :complete_match }

    subject { get :show, id: match.to_param }
    before { ability.can :read, match }

    specify { expect(subject.status).to eq 200 }

    it { is_expected.to render_template :show }

    it "assigns the match as @match" do
      subject
      expect(assigns(:match)).to eq match
    end
  end
end
