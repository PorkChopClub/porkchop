class AddAvatarUrlToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :avatar_url, :string, default: "http://i.imgur.com/ya5NxSH.png"
  end
end
