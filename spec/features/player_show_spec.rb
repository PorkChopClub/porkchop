require 'feature_helper'

RSpec.describe "scoreboard page", js: true do
  let!(:player) { create :player, name: "Candice Bergen" }

  scenario "viewing player page" do
    visit player_path(player)

    expect(page).to have_content(player.name)
    expect(page).to have_content("Elo: 1000")
  end
end
