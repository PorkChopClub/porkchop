require 'visual_spec_helper'

RSpec.describe "Visuals", type: :feature do
  describe "homepage" do
    it do
      visit '/'
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
      visit '/scoreboard'
      sleep 1
      observe! 'scoreboard'
    end
  end

  context 'as admin' do
    let!(:user){ FactoryGirl.create :admin_user }
    before do
      visit '/auth/twitter'
    end

    it "edit active users" do
      visit '/activation/edit'
      expect(page).to have_content 'Active Players'
      observe! 'Active players'
    end

    it "create, and score game" do
      FactoryGirl.create :player, name: "Dave"
      FactoryGirl.create :player, name: "Anne"

      within('nav'){ click_on 'New Match' }

      select 'Dave', from: 'Home player'
      select 'Anne', from: 'Away player'
      observe! 'New Match'

      click_on 'Create Match'

      observe! 'Controls'
    end
  end
end
