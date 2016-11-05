require 'feature_helper'

RSpec.describe "scoreboard page" do
  let!(:table) { create :default_table }

  let!(:other1) { create :player, name: "Dave" }
  let!(:other2) { create :player, name: "Anne" }

  let!(:home) { create :player, name: "Candice Bergen" }
  let!(:away) { create :player, name: "Adam Mueller" }

  let(:match) do
    create :match,
           :at_start,
           home_player: home,
           away_player: away,
           table: table
  end

  scenario "recording a normal game" do
    visit scoreboard_path(table)

    expect(page).to have_content "No match."

    match

    using_wait_time 15 do
      expect(page).to have_content "Candice Bergen versus Adam Mueller"
    end

    # Select service.
    physical_table.home_button

    expect(page).to have_content '0'

    3.times { physical_table.home_button }
    physical_table.away_button

    expect(page).to have_content '3'
    expect(page).to have_content '1'

    8.times { physical_table.home_button }

    expect(page).to have_content 'Candice Bergen defeated Adam Mueller'
    expect(page).to have_content '11 to 1'
  end

  def physical_table
    @physical_table ||=
      PingPong::TableControls.new(match)
  end
end
