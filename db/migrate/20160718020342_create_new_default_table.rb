class CreateNewDefaultTable < ActiveRecord::Migration[5.0]
  def up
    Table.create!(name: "Stembolt Courtney")
  end

  def down
    Table.find_by(name: "Stembolt Courtney").destroy
  end
end
