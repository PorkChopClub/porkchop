require 'rails_helper'

RSpec.describe Api::OngoingMatchesController, type: :controller do
  shared_examples "renders match" do
    it { is_expected.to render_template :show }

    it "assigns the match as @match" do
      subject
      expect(assigns(:match)).to eq match
    end
  end

  describe "GET show" do
    subject { get :show, params: { format: :json } }

    context "when there is an ongoing match" do
      let!(:match) { FactoryGirl.create :match, table: table }
      let(:table) { create :default_table }

      before { subject }

      it { is_expected.to have_http_status :ok }

      it_behaves_like "renders match"
    end

    context "when there is not an ongoing match" do
      it { is_expected.to have_http_status :not_found }
    end
  end

  describe "PUT home_point" do
    subject { put :home_point, params: { format: :json }, session: { write_access: true } }

    let(:table) { create :default_table }

    before { sign_in create(:admin_player) }

    context "when the point can be scored" do
      let!(:match) { FactoryGirl.create :match, table: table, home_score: 0 }

      it_behaves_like "renders match"

      it "scores one for the home team" do
        expect { subject }.
          to change { match.home_points.count }.
          from(0).to(1)
      end
    end

    context "when the point cannot be scored" do
      let!(:match) { FactoryGirl.create :match, :finished, table: table }

      it_behaves_like "renders match"

      it { is_expected.to have_http_status :unprocessable_entity }

      it "doesn't change the home score" do
        expect { subject }.not_to change { match.home_points.count }
      end
    end
  end

  describe "PUT away_point" do
    subject { put :away_point, params: { format: :json }, session: { write_access: true } }

    let(:table) { create :default_table }

    before { sign_in create(:admin_player) }

    context "when the point can be scored" do
      let!(:match) { FactoryGirl.create :match, table: table, away_score: 0 }

      it_behaves_like "renders match"

      it "scores one for the away team" do
        expect { subject }.
          to change { match.away_points.count }.
          from(0).to(1)
      end
    end

    context "when the point cannot be scored" do
      let!(:match) { FactoryGirl.create :match, :finished, table: table }

      it_behaves_like "renders match"

      it { is_expected.to have_http_status :unprocessable_entity }

      it "doesn't change the away score" do
        expect { subject }.not_to change { match.away_points.count }
      end
    end
  end

  describe "PUT toggle_service" do
    subject { put :toggle_service, params: { format: :json }, session: { write_access: true } }

    let!(:match) { FactoryGirl.create :match, :at_start, table: table }
    let(:table) { create :default_table }

    before { sign_in create(:admin_player) }

    context "when the service can be toggled" do
      it_behaves_like "renders match"

      it "toggles the service to the away player" do
        expect { subject }.
          to change {
            PingPong::Match.new(match.reload).home_player_service?
          }.from(nil).to(true)
      end
    end

    context "when the service cannot be toggled" do
      before do
        expect(Match).
          to receive(:ongoing).
          and_return([match])
        expect(match).
          to receive(:toggle_service).
          and_return(false)
      end

      it_behaves_like "renders match"

      it { is_expected.to have_http_status :unprocessable_entity }

      it "doesn't toggle the service" do
        expect { subject }.
          not_to change {
            PingPong::Match.new(match.reload).home_player_service?
          }
      end
    end
  end

  describe "PUT rewind" do
    subject { put :rewind, params: { format: :json }, session: { write_access: true } }

    before { sign_in create(:admin_player) }

    let!(:match) { FactoryGirl.create :match, table: table }
    let(:table) { create :default_table }
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

      it { is_expected.to have_http_status :ok }

      it_behaves_like "renders match"
    end

    context "when the match cannot be rewound" do
      let(:success) { false }

      it { is_expected.to have_http_status :unprocessable_entity }

      it_behaves_like "renders match"
    end
  end

  describe "PUT finalize" do
    subject { put :finalize, params: { format: :json }, session: { write_access: true } }

    before { sign_in create(:admin_player) }

    let!(:match) { FactoryGirl.create :match, table: table }
    let(:table) { create :default_table }

    before do
      expect(MatchFinalizationJob).
        to receive(:perform_later).
        with(match)
    end

    it_behaves_like "renders match"

    it { is_expected.to have_http_status :ok }
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: { format: :json }, session: { write_access: true } }

    before { sign_in create(:admin_player) }

    let!(:complete_match) { FactoryGirl.create :complete_match, table: table }
    let(:table) { create :default_table }

    context "when there is an ongoing match" do
      let!(:match) { FactoryGirl.create :match, table: table }

      it { is_expected.to have_http_status :ok }

      it "destroys the ongoing match" do
        expect { subject }.
          to change { Match.exists? match.id }.
          from(true).to(false)
      end
    end

    context "when there is not an ongoing match" do
      it { is_expected.to have_http_status :unprocessable_entity }

      it "doesn't destroy anything" do
        expect { subject }.not_to change { Match.count }
      end
    end
  end

  describe "PUT matchmake" do
    subject { put :matchmake, params: { format: :json }, session: { write_access: true } }

    before { sign_in create(:admin_player) }

    let!(:table) { create :default_table }
    let!(:player1){ FactoryGirl.create :player, active: true }
    let!(:player2){ FactoryGirl.create :player, active: true }

    let(:new_match){ Match.ongoing.last! }
    let(:new_players){ [new_match.home_player, new_match.away_player] }

    context "when there is an ongoing match" do
      let!(:match) { FactoryGirl.create :match, table: table }

      it { is_expected.to have_http_status :ok }

      it "removes the existing match" do
        expect { subject }.
          to change { Match.exists? match.id }.
          from(true).to(false)
      end

      it "creates a new match" do
        subject
        expect(new_players).to match_array([player1, player2])
      end
    end

    context "when there is not an ongoing match" do
      it { is_expected.to have_http_status :ok }

      it "creates a new match" do
        subject
        expect(new_players).to match_array([player1, player2])
      end
    end
  end
end
