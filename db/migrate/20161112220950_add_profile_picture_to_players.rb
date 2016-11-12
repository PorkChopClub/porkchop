class AddProfilePictureToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :profile_picture, :string
  end
end
