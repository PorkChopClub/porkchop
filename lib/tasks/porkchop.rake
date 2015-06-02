namespace :porkchop do
  desc "Generate sample data"
  task sample_data: [:environment] do
    require 'factory_girl_rails'

    players = Player.all.to_a
    90.downto(0).each do |n|
      puts "Generating matches #{n} days ago."
      finalized_at = n.days.ago.at_beginning_of_day + rand(0..23).hours + rand(0..59).minutes + rand(0..59).seconds
      rand(0..4).times do
        partners = players.shuffle[0..1]

        home = partners[0]
        away = partners[1]
        scores = [11, rand(0..9)].shuffle

        match = FactoryGirl.create :match,
                                   home_player: home,
                                   away_player: away,
                                   home_score: scores[0],
                                   away_score: scores[1]

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
  end

  namespace :elo do
    desc "Regenerate ELO"
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
      end
    end
  end
end
