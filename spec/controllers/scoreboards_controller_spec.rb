require 'rails_helper'

RSpec.describe ScoreboardsController, type: :controller do
  describe "GET show" do
    subject { get :show }
    it { is_expected.to have_http_status :success }
  end

  describe "GET edit" do
    subject { get :edit, session: { write_access: true } }
    before { sign_in create(:admin_player) }
    let(:match) { FactoryGirl.create :match }
    it { is_expected.to have_http_status :success }
  end
end
