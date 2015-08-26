class AddEloToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :elo, :integer, default: 1000
  end
end
