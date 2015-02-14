require 'rails_helper'

RSpec.describe Api::OngoingMatchesController, type: :controller do
  describe "GET show" do
    subject { get :show, format: :json }

    context "when there is an ongoing match" do
      let!(:match) { FactoryGirl.create :match }

      before { subject }

      specify { expect(response.status).to eq 200 }
      specify { expect(assigns(:match)).to eq match }
      specify { expect(response).to render_template :show }
    end

    context "when there is not an ongoing match" do
      specify { expect(subject.status).to eq 404 }
    end
  end

  describe "PUT home_point" do
    subject { put :home_point, format: :json }

    context "when the point can be scored" do
      let!(:match) { FactoryGirl.create :match, home_score: 0 }

      it { is_expected.to render_template :show }

      it "scores one for the home team" do
        expect{subject}.
          to change{match.home_points.count}.
          from(0).to(1)
      end
    end

    context "when the point cannot be scored" do
      let!(:match) { FactoryGirl.create :match, :finished }

      specify { expect(subject.status).to eq 422 }

      it "doesn't change the home score" do
        expect{subject}.not_to change{match.home_points.count}
      end
    end
  end

  describe "PUT away_point" do
    subject { put :away_point, format: :json }

    context "when the point can be scored" do
      let!(:match) { FactoryGirl.create :match, away_score: 0 }

      it { is_expected.to render_template :show }

      it "scores one for the away team" do
        expect{subject}.
          to change{match.away_points.count}.
          from(0).to(1)
      end
    end

    context "when the point cannot be scored" do
      let!(:match) { FactoryGirl.create :match, :finished }

      specify { expect(subject.status).to eq 422 }

      it "doesn't change the away score" do
        expect{subject}.not_to change{match.away_points.count}
      end
    end
  end

  describe "PUT rewind" do
    subject { put :rewind, format: :json }

    let!(:match) { FactoryGirl.create :match }
    let(:rewind) { instance_double PingPong::Rewind }

    before do
      expect(PingPong::Rewind).
        to receive(:new).
        with(instance_of(Match)).
        and_return(rewind)
      expect(rewind).
        to receive(:rewind!).
        and_return(success)
    end

    context "when the match can be rewound" do
      let(:success) { true }

      specify { expect(subject.status).to eq 200 }
      it { is_expected.to render_template :show }
    end

    context "when the match cannot be rewound" do
      let(:success) { false }

      specify { expect(subject.status).to eq 422 }
      it { is_expected.to render_template :show }
    end
  end

  describe "PUT finalize" do
    subject { put :finalize, format: :json }

    context "when the match is finished" do
      let!(:match) { FactoryGirl.create :match, :finished }

      it "finalizes the game" do
        expect{subject}.
          to change{match.reload.finalized?}.
          from(false).to(true)
      end

      it { is_expected.to render_template :show }
    end

    context "when the match is not finished" do
      let!(:match) { FactoryGirl.create :match }

      it "doesn't finalize the game" do
        expect{subject}.not_to change{match.reload.finalized?}
      end

      it { is_expected.to render_template :show }
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, format: :json }

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
