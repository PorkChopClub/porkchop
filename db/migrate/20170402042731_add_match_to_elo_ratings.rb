class AddMatchToEloRatings < ActiveRecord::Migration[5.0]
  def up
    EloRating.delete_all

    add_reference :elo_ratings, :match, foreign_key: true, null: false

    Rake::Task['porkchop:stats:regenerate'].invoke
  end

  def down
    remove_reference :elo_ratings, :match
  end
end
