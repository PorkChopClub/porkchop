require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "POST authenticate" do
    subject { post :authenticate, password: password }

    before do
      request.env["HTTP_REFERER"] = "/the/future"
    end

    context "with the wrong password" do
      let(:password) { "psswrd" }

      it "doesn't authenticate the session" do
        expect { subject }.not_to change { session[:write_access] }
      end

      it { is_expected.to redirect_to "/the/future" }
    end

    context "with the correct password" do
      let(:password) { "password" }

      it "authenticates the session" do
        expect { subject }.to change { session[:write_access] }.from(nil).to(true)
      end

      it { is_expected.to redirect_to "/the/future" }
    end
  end
end
