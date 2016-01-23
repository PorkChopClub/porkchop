class CreateEloRatings < ActiveRecord::Migration
  def change
    create_table :elo_ratings do |t|
      t.belongs_to :player, index: true
      t.integer :rating

      t.timestamps null: false
    end
    add_foreign_key :elo_ratings, :players
  end
end
