require 'rails_helper'

RSpec.describe ActivationsController, type: :controller do
  include_context "controller authorization"

  describe "GET edit" do
    subject { get :edit }
    before { ability.can :update, Player }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :edit }
  end
end
