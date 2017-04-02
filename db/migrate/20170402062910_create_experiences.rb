class CreateExperiences < ActiveRecord::Migration[5.0]
  def change
    create_table :experiences do |t|
      t.integer :xp, null: false
      t.string :reason, null: false
      t.references :source, polymorphic: true, null: false
      t.references :player, foreign_key: true, null: false

      t.timestamps
    end

    add_index :experiences, :source_id
    add_index :experiences, [:reason, :source_id, :source_type], unique: true
  end
end
