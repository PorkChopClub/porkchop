require 'feature_helper'

RSpec.describe "scoreboard page" do
  let!(:home) { FactoryGirl.create :player, name: "Candice Bergen" }
  let!(:away) { FactoryGirl.create :player, name: "Shirley Schmidt" }

  scenario "recording a normal game" do
    visit "/scoreboard/show"

    expect(page).to have_content "Choose the home player!"
    expect(page).to have_content "Candice Bergen"
    expect(page).to have_content "Shirley Schmidt"

    click_button "Candice Bergen"

    expect(page).to have_content "Choose the away player!"
    expect(page).to have_content "Shirley Schmidt"

    click_button "Shirley Schmidt"

    expect(page).to have_content "Who is serving?"

    click_button "Shirley Schmidt"

    # FIXME: Test service logic.

    score_point :home
    score_point :home
    score_point :away
    score_point :away
    score_point :home
    score_point :home

    expect(player_score(:home)).to have_content "4"
    expect(player_score(:away)).to have_content "2"

    score_point :home
    score_point :home
    score_point :home
    score_point :home
    score_point :home
    score_point :home
    score_point :away
    score_point :home

    expect(player_score(:home)).to have_content "11"
    expect(player_score(:away)).to have_content "3"
  end

  private

  def player_score player
    find(".scoreboard-#{player}-player-score")
  end

  def score_point player
    find(".scoreboard-#{player}-player").click
  end
end
