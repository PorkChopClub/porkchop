class RipAvatarUrls < ActiveRecord::Migration[5.0]
  def change
    rename_column :players, :avatar_url, :legacy_avatar_url
  end
end
