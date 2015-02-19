class AddFirstServiceByHomePlayerToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :first_service_by_home_player, :boolean, default: true
  end
end
