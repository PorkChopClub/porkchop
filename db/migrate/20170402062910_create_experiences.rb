class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.integer :xp, null: false
      t.string :reason, null: false
      t.references :match, foreign_key: true, null: false
      t.references :player, foreign_key: true, null: false

      t.timestamps
    end

    add_index :experiences, [:reason, :player_id, :match_id], unique: true
  end
end
