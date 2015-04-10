require 'spec_helper'
require 'matchmaker'

class MockMatchmakerPlayer
  attr_reader :last_played_at, :times_played

  def initialize
    @last_played_at = nil
    @times_played = 0
  end

  def play(time=Time.current)
    @last_played_at = time
    @times_played += 1
  end
end

RSpec.shared_examples "a fair matchmaker" do
  it "should allow each player to a game in as many games" do
    num_players.times { play_match }
    players.each do |player|
      expect(player.times_played).to be > 0
    end
  end

  it "should give each player a balanced number of games" do
    n = 1000

    # Each player should expect to play once for every N/2 games
    # This spec fails if they don't achieve half that
    fair_ratio = (1.0 / num_players)

    n.times { play_match }
    players.each do |player|
      expect(player.times_played).to be > (n * fair_ratio)
    end
  end
end

RSpec.describe Matchmaker do
  def mock_player
    MockMatchmakerPlayer.new
  end

  def play_match
    @matches_played ||= 0
    @matches_played += 1

    time = Time.at(@matches_played)

    playing = described_class.new(players).choose
    playing.each{|player| player.play(time) }
  end

  let(:players){ Array.new(num_players){ mock_player } }

  [2, 3, 4, 5, 6, 7, 8, 9, 10].each do |n|
    context "with #{n} players" do
      let(:num_players){ n }
      it_behaves_like "a fair matchmaker"
    end
  end
end
