require 'rails_helper'

RSpec.describe Api::StatsController, type: :controller do
  render_views

  describe "GET points" do
    subject { get :points, format: :json }

    let(:player1) { FactoryGirl.create :player, name: "Jared" }
    let(:player2) { FactoryGirl.create :player, name: "Gray" }
    let!(:player3) { FactoryGirl.create :player, name: "Clarke" }
    let!(:match1) {
      FactoryGirl.create :match,
        home_player: player1,
        away_player: player2,
        home_score: 11,
        away_score: 5
    }
    let!(:match2) {
      FactoryGirl.create :match,
        home_player: player1,
        away_player: player2,
        home_score: 13,
        away_score: 15
    }

    it "renders the players by total score" do
      expect(JSON.parse(subject.body)['points']).to eq [
        ["Jared", 24], ["Gray", 20]
      ]
    end
  end
end
