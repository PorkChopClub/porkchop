class CorrectHistoricalRatings < ActiveRecord::Migration
  def up
    Match.all.order(finalized_at: :asc).find_each do |match|
      EloAdjustment.new(
        victor: match.victor,
        loser: match.loser
      ).adjust!

      EloRating.
        order(created_at: :desc).
        limit(2).
        update_all(created_at: match.finalized_at)
    end
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
