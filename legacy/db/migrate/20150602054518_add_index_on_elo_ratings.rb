class AddIndexOnEloRatings < ActiveRecord::Migration
  def change
    add_index :elo_ratings, [:player_id, :created_at]
  end
end
