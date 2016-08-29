require 'feature_helper'

RSpec.describe "scoreboard page" do
  let!(:other1) { create :player, name: "Dave" }
  let!(:other2) { create :player, name: "Anne" }

  let!(:home) { create :player, name: "Candice Bergen" }
  let!(:away) { create :player, name: "Adam Mueller" }
  let!(:table) { create :default_table }

  scenario "recording a normal game" do
    visit '/scoreboard'

    # Blank page

    create_match

    expect(page).to have_content(home.name)
    expect(page).to have_content(away.name)
    expect(page).to have_content("Waiting for match to start")

    physical_table.home_button
    expect(page).to have_content("This is the first match between these players")
    expect(page).to have_css('.scoreboard-home-player.has-service')
    expect(page).to have_no_content("Select first service")

    physical_table.away_button
    physical_table.home_button
    physical_table.home_button

    within '.scoreboard-home-player-score' do
      expect(page).to have_content '2'
    end
    within '.scoreboard-away-player-score' do
      expect(page).to have_content '1'
    end
    expect(page).to have_css('.scoreboard-away-player.has-service')

    8.times { physical_table.home_button }

    expect(page).to have_content('Game point')
    physical_table.home_button

    expect(page).to have_content('Press to finalize')
    physical_table.home_button

    # blank page again
  end

  def create_match
    @match = create :match, :at_start, home_player: home, away_player: away, table: table
  end

  def physical_table
    PingPong::TableControls.new(PingPong::Match.new(@match))
  end
end
