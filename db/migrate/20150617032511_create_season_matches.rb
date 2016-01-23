class CreateSeasonMatches < ActiveRecord::Migration
  def change
    create_table :season_matches do |t|
      t.belongs_to :match, index: true
      t.belongs_to :season, index: true

      t.timestamps null: false
    end
    add_foreign_key :season_matches, :matches
    add_foreign_key :season_matches, :seasons
  end
end
