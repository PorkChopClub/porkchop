require 'rails_helper'

RSpec.describe Api::StatsController, type: :controller do
  render_views

  describe "GET win_percentage" do
    subject { get :win_percentage, format: :json }

    let(:player1) { FactoryGirl.create :player, name: "Jared" }
    let(:player2) { FactoryGirl.create :player, name: "Gray" }
    let!(:player3) { FactoryGirl.create :player, name: "Clarke" }

    let!(:match1) {
      FactoryGirl.create :match,
        home_player: player1,
        away_player: player2,
        victor: player1
    }
    let!(:match2) {
      FactoryGirl.create :match,
        home_player: player1,
        away_player: player2,
        victor: player2
    }
    let!(:match3) {
      FactoryGirl.create :match,
        home_player: player1,
        away_player: player2,
        victor: player1
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
