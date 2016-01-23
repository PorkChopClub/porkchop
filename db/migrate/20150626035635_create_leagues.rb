class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.timestamps null: false
    end

    add_column :seasons, :league_id, :integer
    add_foreign_key :seasons, :leagues
  end
end
