require 'feature_helper'

RSpec.describe "scoreboard page" do
  let!(:table) { create :default_table }

  let!(:other1) { create :player, name: "Dave" }
  let!(:other2) { create :player, name: "Anne" }

  let!(:home) { create :player, name: "Candice Bergen" }
  let!(:away) { create :player, name: "Adam Mueller" }

  def update_channel
    OngoingMatchChannel.broadcast_update(table: table)
  end

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
    update_channel

    using_wait_time 15 do
      expect(page).to have_content "Candice Bergen"
      expect(page).to have_content "Adam Mueller"
    end

    # Select service.
    home_button

    expect(page).to have_content '0'

    3.times { home_button }
    away_button

    expect(page).to have_content '3'
    expect(page).to have_content '1'

    8.times { home_button }
  end

  def away_button
    physical_table.away_button
    update_channel
  end

  def home_button
    physical_table.home_button
    update_channel
  end

  def physical_table
    @physical_table ||=
      PingPong::TableControls.new(match)
  end
end
