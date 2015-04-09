class AddActiveToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :active, :boolean, default: false
  end
end
