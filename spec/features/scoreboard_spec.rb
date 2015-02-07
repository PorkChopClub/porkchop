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

    7.times { score_point :home }
    9.times { score_point :away }
    3.times { score_point :home }

    expect(page).to have_content "Finalize the game?!"

    click_button "Yes, please!"

    # FIXME: View game result page that doesn't exist at time of writing.
    expect(Match.count).to eq 1
  end

  private

  def player_score player
    find(".scoreboard-#{player}-player-score")
  end

  def score_point player
    find(".scoreboard-#{player}-player").click
  end
end
