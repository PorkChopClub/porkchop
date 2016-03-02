class CreateBettingInfos < ActiveRecord::Migration
  def change
    create_table :betting_infos do |t|
      t.references :match, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
