require 'feature_helper'

RSpec.describe "controls page" do
  let!(:other1) { FactoryGirl.create :player, name: "Dave" }
  let!(:other2) { FactoryGirl.create :player, name: "Anne" }

  let!(:home) { FactoryGirl.create :player, name: "Candice Bergen" }
  let!(:away) { FactoryGirl.create :player, name: "Shirley Schmidt" }

  let!(:user) { FactoryGirl.create :admin_user }

  scenario "recording a normal game" do
    visit "/auth/twitter"

    visit "/matches/new"

    select "Candice Bergen", from: "Away player"
    select "Shirley Schmidt", from: "Home player"

    click_on "Create Match"

    score_point :away

    click_on "Cancel match"
    click_on "Confirm cancellation"

    select "Candice Bergen", from: "Home player"
    select "Shirley Schmidt", from: "Away player"

    click_on "Create Match"

    expect(player_score(:home)).to have_content "0"
    expect(player_score(:away)).to have_content "0"

    # Select home service
    score_point :home

    score_point :away
    score_point :home
    score_point :away
    score_point :home
    score_point :home

    expect(player_score(:home)).to have_content "3"
    expect(player_score(:away)).to have_content "2"

    click_button "Rewind a point"
    click_button "Rewind a point"

    expect(player_score(:home)).to have_content "1"
    expect(player_score(:away)).to have_content "2"

    10.times { score_point :home }

    expect(player_score(:home)).to have_content "11"
    expect(player_score(:away)).to have_content "2"

    click_button "Finalize match"
    click_button "Confirm finalization"

    expect(page).to have_content "Candice Bergen wins!"
  end

  private

  def player_score(player)
    find(".match-controls-#{player}-player-score")
  end

  def score_point(player)
    find(".match-controls-#{player}-player").click
  end
end
