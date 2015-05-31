class CreateStreaks < ActiveRecord::Migration
  def change
    create_table :streaks do |t|
      t.references :player, index: true
      t.string :streak_type
      t.integer :streak_length
      t.datetime :finished_at

      t.timestamps
    end

    add_foreign_key :streaks, :players
  end
end
