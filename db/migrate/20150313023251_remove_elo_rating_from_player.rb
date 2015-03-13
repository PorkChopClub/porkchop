class RemoveEloRatingFromPlayer < ActiveRecord::Migration
  def up
    remove_column :players, :elo
  end

  def down
    add_column :players, :elo, :integer, default: 1000
  end
end
