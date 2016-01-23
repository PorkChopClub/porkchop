class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.belongs_to :home_player, index: true
      t.belongs_to :away_player, index: true
      t.belongs_to :victor, index: true
      t.datetime :finalized_at

      t.timestamps null: false
    end
    add_foreign_key :matches, :players, column: :home_player_id
    add_foreign_key :matches, :players, column: :away_player_id
    add_foreign_key :matches, :players, column: :victor_id
  end
end
