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

  describe "GET new" do
    subject { get :new }
    before { ability.can :create, Match }

    context "when there is not an ongoing match" do
      before do
        allow(Matchmaker).
          to receive(:choose).
          and_return(matchup)
      end

      let(:matchup) { instance_double Matchup }

      specify { expect(subject.status).to eq 200 }

      it "grabs the next matchup" do
        subject
        expect(assigns(:matchup)).to eq matchup
      end

      it { is_expected.to render_template :new }
    end

    context "when there is already an ongoing match" do
      let!(:ongoing_match) { FactoryGirl.create :match }

      it { is_expected.to redirect_to edit_scoreboard_path }
    end
  end

  describe "POST create" do
    subject { post :create }
    before { ability.can :create, Match }

    context "when there is not an ongoing match" do
      context "with valid params" do
        it { is_expected.to redirect_to edit_scoreboard_path }

        it "sets up a match" do
          expect(Match).to receive(:setup!)
          subject
        end
      end
    end

    context "when there is already an ongoing match" do
      let(:match_params) { {} }
      let!(:ongoing_match) { FactoryGirl.create :match }

      it { is_expected.to redirect_to edit_scoreboard_path }

      it "doesn't create a match" do
        expect { subject }.not_to change { Match.count }
      end
    end
  end
end
