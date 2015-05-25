class CreateSeasonMemberships < ActiveRecord::Migration
  def change
    create_table :season_memberships do |t|
      t.references :player, index: true
      t.references :season, index: true

      t.timestamps null: false
    end
    add_foreign_key :season_memberships, :players
    add_foreign_key :season_memberships, :seasons
  end
end
