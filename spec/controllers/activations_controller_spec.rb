require 'rails_helper'

RSpec.describe ActivationsController do
  describe "GET #activate" do
    subject { get :activate }

    context "when logged in" do
      before { sign_in player }

      context "when the player is not active" do
        let(:player) { create :player, :confirmed }

        it { is_expected.to redirect_to "/" }

        it "informs the user they have been activated" do
          subject
          expect(flash[:notice]).
            to eq "You've been queued to play."
        end

        it "queues the player" do
          expect { subject }.
            to change { player.reload.active }.
            from(false).to(true)
        end
      end

      context "when the player is already active" do
      end
    end

    context "when not logged in" do
      it { is_expected.to redirect_to "/players/sign_in" }

      it "informs the user they haven't been activated" do
        subject
        expect(flash[:alert]).
          to eq "You must be logged in to queue to play."
      end
    end
  end
end
