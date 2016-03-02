class AddSpreadToBettingInfos < ActiveRecord::Migration
  def change
    add_column :betting_infos, :spread, :decimal, precision: 3, scale: 1
    add_reference :betting_infos, :favourite, index: true, foreign_key: false
    add_foreign_key :betting_infos, :players, column: :favourite_id
  end
end
