require 'visual_helper'

RSpec.describe "Visuals", type: :feature do
  describe "homepage" do
    it do
      visit root_path
      observe! 'Homepage'
    end
  end

  context "with a running game" do
    let!(:player1) { FactoryGirl.create :player, name: "Dave" }
    let!(:player2) { FactoryGirl.create :player, name: "Anne" }

    let!(:match) do
      FactoryGirl.create :new_match, home_player: player1, away_player: player2
    end

    it "scoreboard" do
      login_as create(:admin_player)

      visit scoreboard_path(match.table)

      sleep 1
      observe! 'scoreboard'
    end
  end
end
