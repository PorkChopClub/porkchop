require 'rails_helper'

RSpec.describe Api::StatsController, type: :controller do
  render_views

  describe "GET win_percentage" do
    subject { get :win_percentage, format: :json }

    let(:jared) { FactoryGirl.create :player, name: "Jared" }
    let(:gray) { FactoryGirl.create :player, name: "Gray" }
    let!(:clarke) { FactoryGirl.create :player, name: "Clarke" }

    let!(:match1) {
      FactoryGirl.create :complete_match,
        home_player: jared,
        away_player: gray,
        victor: jared
    }
    let!(:match2) {
      FactoryGirl.create :complete_match,
        home_player: jared,
        away_player: gray,
        victor: gray
    }
    let!(:match3) {
      FactoryGirl.create :complete_match,
        home_player: jared,
        away_player: gray,
        victor: jared
    }

    it "renders the players by total score" do
      expect(JSON.parse(subject.body)['percentages']).to eq({
        "Jared" => 0.667,
        "Gray" => 0.333,
        "Clarke" => 0.0
      })
    end
  end
end
