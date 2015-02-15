require 'rails_helper'

RSpec.describe MatchesController, type: :controller do
  describe "GET new" do
    subject { get :new }

    context "when there is not an ongoing match" do
      specify { expect(subject.status).to eq 200 }
      it { is_expected.to render_template :new }
    end

    context "when there is already an ongoing match" do
      let!(:ongoing_match) { FactoryGirl.create :match }

      it { is_expected.to redirect_to edit_scoreboard_path }
    end
  end

  describe "POST create" do
    subject { post :create, match: match_params }

    context "when there is not an ongoing match" do
      context "with valid params" do
        let(:home_player) { FactoryGirl.create :player }
        let(:away_player) { FactoryGirl.create :player }

        let(:match_params) { {
          home_player_id: home_player.to_param,
          away_player_id: away_player.to_param
        } }

        it { is_expected.to redirect_to edit_scoreboard_path }

        it "creates a match" do
          expect{subject}.
            to change{Match.count}.
            from(0).to(1)
        end
      end

      context "with invalid params" do
        let(:match_params) { { foo: 'bar' } }

        it { is_expected.to render_template :new }

        it "doesn't create a match" do
          expect{subject}.not_to change{Match.count}
        end
      end
    end

    context "when there is already an ongoing match" do
      let(:match_params) { {} }
      let!(:ongoing_match) { FactoryGirl.create :match }

      it { is_expected.to redirect_to edit_scoreboard_path }

      it "doesn't create a match" do
        expect{subject}.not_to change{Match.count}
      end
    end
  end
end
