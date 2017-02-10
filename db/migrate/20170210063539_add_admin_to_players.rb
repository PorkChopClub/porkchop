class AddAdminToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :admin, :boolean, null: false, default: :false
  end
end
