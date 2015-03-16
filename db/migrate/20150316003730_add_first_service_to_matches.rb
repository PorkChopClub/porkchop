class AddFirstServiceToMatches < ActiveRecord::Migration
  def up
    add_column :matches, :first_service, :integer
    Match.where(first_service_by_home_player: true).update_all(first_service: 1)
    Match.where(first_service_by_home_player: false).update_all(first_service: 2)
    remove_column :matches, :first_service_by_home_player
  end
  def down
    add_column :matches, :first_service_by_home_player, :boolean, default: true
    Match.where(first_service: 2).update_all(first_service_by_home_player: false)
    remove_column :matches, :first_service, :integer
  end
end
