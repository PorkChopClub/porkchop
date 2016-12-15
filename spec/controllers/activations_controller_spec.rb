require 'rails_helper'

RSpec.describe ActivationsController do
  shared_examples "activate" do
    context "when logged in" do
      before { sign_in player }

      context "when the player is not active" do
        let(:player) { create :player, :confirmed }

        it { is_expected.to redirect_to "/" }

        it "informs the player they have been activated" do
          subject
          expect(flash[:notice]).to eq "You've been queued to play."
        end

        it "queues the player" do
          expect { subject }.
            to change { player.reload.active }.
            from(false).to(true)
        end

        context "when HTTP_REFERER is set" do
          before { request.env['HTTP_REFERER'] = '/potato' }

          it { is_expected.to redirect_to '/potato' }
        end
      end

      context "when the player is already active" do
        let(:player) { create :player, :confirmed, active: true }

        it { is_expected.to redirect_to "/" }

        it "informs the player they have been activated" do
          subject
          expect(flash[:alert]).to eq "You were already in the queue."
        end

        context "when HTTP_REFERER is set" do
          before { request.env['HTTP_REFERER'] = '/potato' }

          it { is_expected.to redirect_to '/potato' }
        end
      end
    end

    context "when not logged in" do
      it { is_expected.to redirect_to "/players/sign_in" }

      it "informs the player they haven't been activated" do
        subject
        expect(flash[:alert]).to eq "You must be logged in to queue to play."
      end
    end
  end

  describe "GET #activate" do
    subject { get :activate }
    include_examples "activate"
  end

  describe "POST #activate" do
    subject { post :activate }
    include_examples "activate"
  end
end
