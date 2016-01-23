class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :games_per_matchup
      t.datetime :finalized_at

      t.timestamps null: false
    end
  end
end
