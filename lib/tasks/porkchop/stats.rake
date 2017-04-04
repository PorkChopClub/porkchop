namespace :porkchop do
  namespace :stats do
    desc "Regenerate ELO and streaks"
    task regenerate: [:environment] do
      EloRating.delete_all
      Stats::Streak.delete_all

      Match.all.finalized.order(finalized_at: :asc).find_each do |match|
        EloAdjustment.new(
          victor: match.victor,
          loser: match.loser,
          match: match
        ).adjust!

        EloRating.
          order(created_at: :desc).
          limit(2).
          update_all(created_at: match.finalized_at)

        Stats::StreakAdjustment.new(
          player: match.victor,
          match_result: "W",
          finished_at: match.finalized_at
        ).adjust!

        Stats::StreakAdjustment.new(
          player: match.loser,
          match_result: "L",
          finished_at: match.finalized_at
        ).adjust!
      end
    end
  end
end
