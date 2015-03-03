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

  describe "GET rating" do
    subject { get :rating, format: :json }

    let!(:jared) do
      FactoryGirl.create :player, name: "Jared", elo: 1200
    end
    let!(:gray) do
      FactoryGirl.create :player, name: "Gray", elo: 1000
    end
    let!(:clarke) do
      FactoryGirl.create :player, name: "Clarke", elo: 900
    end

    before do
      allow_any_instance_of(Player).
        to receive_message_chain(:matches, :finalized, :count) { 20 }
    end

    it "renders the players by elo" do
      expect(JSON.parse(subject.body)['ratings']).to eq([
        ["Jared", 1200],
        ["Gray", 1000],
        ["Clarke", 900]
      ])
    end
  end
end
