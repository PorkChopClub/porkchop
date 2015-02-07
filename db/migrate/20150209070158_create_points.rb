class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.references :match, index: true
      t.references :victor, index: true

      t.timestamps null: false
    end
    add_foreign_key :points, :matches
    add_foreign_key :points, :players, column: :victor_id
  end
end
