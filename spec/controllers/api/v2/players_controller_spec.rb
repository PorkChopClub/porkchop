require 'rails_helper'

RSpec.describe Api::V2::PlayersController do
  describe "GET #index" do
    subject { get :index }

    it { is_expected.to have_http_status :ok }
  end
end
