require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    subject { get :index }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to render_template :index }
  end
end
