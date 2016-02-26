require 'feature_helper'

RSpec.describe "scoreboard page" do
  let!(:other1) { FactoryGirl.create :player, name: "Dave" }
  let!(:other2) { FactoryGirl.create :player, name: "Anne" }

  let!(:home) { FactoryGirl.create :player, name: "Candice Bergen" }
  let!(:away) { FactoryGirl.create :player, name: "Adam Mueller" }

  scenario "recording a normal game" do
    visit '/scoreboard'

    # Blank page

    create_match

    expect(page).to have_content(home.name)
    expect(page).to have_content(away.name)
    expect(page).to have_content("01:30")
    expect(page).to have_content("SELECT FIRST SERVICE")

    table.home_button
    expect(page).to have_content("This is the first match between these players")
    expect(page).to have_css('.scoreboard-home-player.has-service')
    expect(page).to have_no_content("SELECT FIRST SERVICE")

    table.away_button
    table.home_button
    table.home_button

    within '.scoreboard-home-player-score' do
      expect(page).to have_content '2'
    end
    within '.scoreboard-away-player-score' do
      expect(page).to have_content '1'
    end
    expect(page).to have_css('.scoreboard-away-player.has-service')

    8.times { table.home_button }

    expect(page).to have_content('Game point')
    table.home_button

    expect(page).to have_content('PRESS TO FINALIZE')
    table.home_button

    # blank page again
  end

  def create_match
    @match = FactoryGirl.create :match, :at_start, home_player: home, away_player: away
  end

  def table
    PingPong::TableControls.new(PingPong::Match.new(@match))
  end
end
