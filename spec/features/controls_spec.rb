require 'feature_helper'

RSpec.describe "controls page" do
  let!(:other1) { FactoryGirl.create :player, name: "Dave" }
  let!(:other2) { FactoryGirl.create :player, name: "Anne" }

  let!(:home) { FactoryGirl.create :player, active: true, name: "Candice Bergen" }
  let!(:away) { FactoryGirl.create :player, active: true, name: "Shirley Schmidt" }

  let!(:user) { FactoryGirl.create :admin_user }

  scenario "recording a normal game" do
    visit "/"
    fill_in :password, with: "password"
    click_button "Submit"
    visit "/scoreboard/edit"
    click_on "Matchmake"

    expect(player_name(:home)).to have_content "Candice"
    expect(player_name(:away)).to have_content "Shirley"

    score_point :away

    click_on "Cancel match"
    click_on "Matchmake"

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

    # Wait for the 1s polling on this page.
    sleep 1

    expect(player_name(:home)).to have_content "Shirley"
    expect(player_name(:away)).to have_content "Candice"

    expect(Match.finalized.count).to eq 1
  end

  private

  def player_name(player)
    find(".match-controls-#{player}-player-name")
  end

  def player_score(player)
    find(".match-controls-#{player}-player-score")
  end

  def score_point(player)
    find(".match-controls-#{player}-player").click
  end
end
