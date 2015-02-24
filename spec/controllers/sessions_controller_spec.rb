require 'rails_helper'
require 'omniauth_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET create" do
    subject { get :create, provider: :twitter }

    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    end

    it "creates a user" do
      expect{subject}.
        to change{User.count}.
        from(0).to(1)
    end

    it { is_expected.to redirect_to "/" }

    it "sets the user_id on the session" do
      expect{subject}.
        to change{session[:user_id]}.
        from(nil)
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy }

    before do
      session[:user_id] = 1
    end

    it { is_expected.to redirect_to "/" }

    it "removes the user_id from the session" do
      expect{subject}.
        to change{session[:user_id]}.
        from(1).to(nil)
    end
  end
end
