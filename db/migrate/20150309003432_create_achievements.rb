class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.belongs_to :player
      t.string :variety
      t.integer :rank, default: 0

      t.timestamps null: false
    end
    add_foreign_key :achievements, :players
  end
end
