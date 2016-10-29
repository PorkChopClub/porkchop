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
      visit scoreboard_path(match.table)

      sleep 1
      observe! 'scoreboard'
    end
  end

  context 'as admin' do
    before do
      create :default_table
      login_as create(:admin_player), scope: :player
    end

    it "create, and score game" do
      FactoryGirl.create :player, name: "Dave", active: true
      FactoryGirl.create :player, name: "Anne", active: true

      visit '/scoreboard/edit'

      sleep 1
      observe! 'New Match'

      click_on 'Matchmake'

      sleep 1
      observe! 'Controls'
    end
  end
end
