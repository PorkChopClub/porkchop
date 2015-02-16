require 'feature_helper'

RSpec.describe "scoreboard page" do
  let!(:home) { FactoryGirl.create :player, name: "Candice Bergen" }
  let!(:away) { FactoryGirl.create :player, name: "Shirley Schmidt" }

  scenario "recording a normal game" do
    visit "/matches/new"

    select "Candice Bergen", from: "Home player"
    select "Shirley Schmidt", from: "Away player"

    click_on "Create Match"

    expect(player_score(:home)).to have_content "0"
    expect(player_score(:away)).to have_content "0"

    score_point :away
    score_point :home
    score_point :away
    score_point :home
    score_point :home

    expect(player_score(:home)).to have_content "3"
    expect(player_score(:away)).to have_content "2"

    click_button "Rewind Game"
    click_button "Rewind Game"

    expect(player_score(:home)).to have_content "1"
    expect(player_score(:away)).to have_content "2"

    10.times { score_point :home }

    expect(player_score(:home)).to have_content "11"
    expect(player_score(:away)).to have_content "2"

    click_button "Finalize Game"

    expect(page).to have_content "Create Match"
  end

  private

  def player_score player
    find(".match-controls-#{player}-player-score")
  end

  def score_point player
    find(".match-controls-#{player}-player").click
  end
end
