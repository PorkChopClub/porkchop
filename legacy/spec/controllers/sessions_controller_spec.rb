require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "POST authenticate" do
    subject { post :authenticate, password: password }

    before do
      request.env["HTTP_REFERER"] = "/the/future"
    end

    context "with the wrong password" do
      let(:password) { "psswrd" }

      it { is_expected.to have_http_status :unauthorized }

      it "sets the authenticates the session" do
        expect { subject }.not_to change { session[:write_access] }
      end
    end

    context "with the correct password" do
      let(:password) { "password" }

      it { is_expected.to have_http_status :ok }

      it "sets the authenticates the session" do
        expect { subject }.to change { session[:write_access] }.from(nil).to(true)
      end
    end
  end
end
