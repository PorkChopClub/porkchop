class MakeTablesHappen < ActiveRecord::Migration[5.0]
  def up
    main_table = Table.create!(name: "Stembolt Langley")

    %i(matches seasons leagues).each do |table_name|
      add_reference table_name, :table, index: true, foreign_key: true
    end

    Match.update_all table_id: main_table.id
    Season.update_all table_id: main_table.id
    League.update_all table_id: main_table.id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "I'm honestly just too lazy to implement it."
  end
end
