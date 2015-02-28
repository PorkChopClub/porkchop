require 'rails_helper'

RSpec.describe Api::OngoingMatchesController, type: :controller do
  include_context "controller authorization"

  shared_examples "renders match" do
    it { is_expected.to render_template :show }

    it "assigns the match as @match" do
      subject
      expect(assigns(:match)).to eq match
    end
  end

  describe "GET show" do
    subject { get :show, format: :json }
    before { ability.can :read, PingPong::Match }

    context "when there is an ongoing match" do
      let!(:match) { FactoryGirl.create :match }

      before { subject }

      specify { expect(response.status).to eq 200 }

      it_behaves_like "renders match"
    end

    context "when there is not an ongoing match" do
      specify { expect(subject.status).to eq 404 }
    end
  end

  describe "PUT home_point" do
    subject { put :home_point, format: :json }
    before { ability.can :update, PingPong::Match }

    context "when the point can be scored" do
      let!(:match) { FactoryGirl.create :match, home_score: 0 }

      it_behaves_like "renders match"

      it "scores one for the home team" do
        expect{subject}.
          to change{match.home_points.count}.
          from(0).to(1)
      end
    end

    context "when the point cannot be scored" do
      let!(:match) { FactoryGirl.create :match, :finished }

      it_behaves_like "renders match"

      specify { expect(subject.status).to eq 422 }

      it "doesn't change the home score" do
        expect{subject}.not_to change{match.home_points.count}
      end
    end
  end

  describe "PUT away_point" do
    subject { put :away_point, format: :json }
    before { ability.can :update, PingPong::Match }

    context "when the point can be scored" do
      let!(:match) { FactoryGirl.create :match, away_score: 0 }

      it_behaves_like "renders match"

      it "scores one for the away team" do
        expect{subject}.
          to change{match.away_points.count}.
          from(0).to(1)
      end
    end

    context "when the point cannot be scored" do
      let!(:match) { FactoryGirl.create :match, :finished }

      it_behaves_like "renders match"

      specify { expect(subject.status).to eq 422 }

      it "doesn't change the away score" do
        expect{subject}.not_to change{match.away_points.count}
      end
    end
  end

  describe "PUT toggle_service" do
    let!(:match) { FactoryGirl.create :match, :at_start }

    subject { put :toggle_service, format: :json }
    before { ability.can :update, PingPong::Match }

    context "when the service can be toggled" do
      it_behaves_like "renders match"

      it "toggles the service to the away player" do
        expect{subject}.
          to change {
            PingPong::Match.new(match.reload).home_player_service?
          }.from(true).to(false)
      end
    end

    context "when the service cannot be toggled" do
      before do
        expect(Match).
          to receive(:ongoing).
          and_return([match])
        expect(match).
          to receive(:toggle!).
          with(:first_service_by_home_player).
          and_return(false)
      end

      it_behaves_like "renders match"

      specify { expect(subject.status).to eq 422 }

      it "doesn't toggle the service" do
        expect{subject}.
          not_to change {
            PingPong::Match.new(match.reload).home_player_service?
          }
      end
    end
  end

  describe "PUT rewind" do
    subject { put :rewind, format: :json }
    before { ability.can :update, PingPong::Match }

    let!(:match) { FactoryGirl.create :match }
    let(:rewind) { instance_double PingPong::Rewind }

    before do
      expect(PingPong::Rewind).
        to receive(:new).
        with(instance_of(PingPong::Match)).
        and_return(rewind)
      expect(rewind).
        to receive(:rewind!).
        and_return(success)
    end

    context "when the match can be rewound" do
      let(:success) { true }

      specify { expect(subject.status).to eq 200 }

      it_behaves_like "renders match"
    end

    context "when the match cannot be rewound" do
      let(:success) { false }

      specify { expect(subject.status).to eq 422 }

      it_behaves_like "renders match"
    end
  end

  describe "PUT finalize" do
    subject { put :finalize, format: :json }
    before { ability.can :update, PingPong::Match }

    let!(:match) { FactoryGirl.create :match }
    let(:finalization) {
      instance_double PingPong::Finalization, finalize!: finalized
    }

    before do
      expect(PingPong::Finalization).
        to receive(:new).
        and_return(finalization)
    end

    context "when the match can be finalized" do
      let(:finalized) { true }

      it_behaves_like "renders match"

      specify { expect(subject.status).to eq 200 }
    end

    context "when the match cannot be finalized" do
      let(:finalized) { false }

      it_behaves_like "renders match"

      specify { expect(subject.status).to eq 422 }
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, format: :json }
    before { ability.can :update, PingPong::Match }

    let!(:complete_match) { FactoryGirl.create :complete_match }

    context "when there is an ongoing match" do
      let!(:match) { FactoryGirl.create :match }

      specify { expect(subject.status).to eq 200 }

      it "destroys the ongoing match" do
        expect{subject}.
          to change{Match.exists? match.id}.
          from(true).to(false)
      end
    end

    context "when there is not an ongoing match" do
      specify { expect(subject.status).to eq 422 }

      it "doesn't destroy anything" do
        expect{subject}.not_to change{Match.count}
      end
    end
  end
end
