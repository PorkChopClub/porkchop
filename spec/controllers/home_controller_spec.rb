require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET index" do
    subject { get :index }

    let!(:recent_match) { FactoryGirl.create :complete_match }
    let!(:ongoing_match) { FactoryGirl.create :match }
    let!(:gray) { FactoryGirl.create :player, name: "Gray", elo: 1000 }
    let(:match_history) { FactoryGirl.create_list :complete_match, 20, home_player: gray }

    specify { expect(subject.status).to eq 200 }
    it { is_expected.to render_template :index }
  end
end
