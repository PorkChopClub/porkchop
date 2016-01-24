namespace :porkchop do
  desc "Pretend someone is pressing buttons on the table"
  task press_buttons: [:environment] do
    loop do
      sleep rand(0.2..0.8)
      match = PingPong::Match.new(Match.ongoing.first)
      controls = PingPong::TableControls.new(match)
      case rand(2)
      when 0
        puts "Home button!"
        controls.home_button
      when 1
        puts "Away button!"
        controls.away_button
      end
    end
  end

  desc "Generate sample data"
  task create_season: [:environment] do
    league = League.create name: "PorkChop Club"
    season = Season.create games_per_matchup: 4, league: league
    season.players << Player.all
  end

  task simulate_matches: [:environment] do
    require 'factory_girl_rails'

    Player.update_all active: true
    Match.setup!

    90.downto(0).each do |n|
      puts "Generating matches #{n} days ago."
      finalized_at = n.days.ago.at_beginning_of_day + rand(0..23).hours + rand(0..59).minutes + rand(0..59).seconds
      rand(0..4).times do
        match = Match.ongoing.last

        scores = [11, rand(0..9)].shuffle
        FactoryGirl.create_list :point, scores[0], victor: match.home_player, match: match
        FactoryGirl.create_list :point, scores[1], victor: match.away_player, match: match

        PingPong::Finalization.new(
          PingPong::Match.new(match)
        ).finalize!

        EloRating.
          order(created_at: :desc).
          limit(2).
          update_all(created_at: finalized_at)

        match.update_column :finalized_at, finalized_at
      end
    end

    Match.ongoing.last.destroy
    Player.update_all active: false
  end

  namespace :stats do
    desc "Regenerate ELO and streaks"
    task regenerate: [:environment] do
      EloRating.delete_all

      Match.all.finalized.order(finalized_at: :asc).find_each do |match|
        EloAdjustment.new(
          victor: match.victor,
          loser: match.loser,
          matches: match.all_matches_before
        ).adjust!

        EloRating.
          order(created_at: :desc).
          limit(2).
          update_all(created_at: match.finalized_at)

        Stats::StreakAdjustment.new(
          player: match.victor,
          match_result: "W"
        ).adjust!
        Stats::StreakAdjustment.new(
          player: match.loser,
          match_result: "L"
        ).adjust!
      end
    end
  end
end
