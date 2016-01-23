class AdjustPlayerRatings < ActiveRecord::Migration
  def up
    Match.finalized.order(finalized_at: :asc).find_each do |match|
      EloAdjustment.new(victor: match.victor,
                        loser: match.loser).adjust!
    end
  end

  def down
    Player.update_all elo: 1000
  end
end
