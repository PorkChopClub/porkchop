class ChangeMyMindAboutTableOnSeasons < ActiveRecord::Migration[5.0]
  def up
    remove_column :seasons, :table_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Yeah no that's not going to work."
  end
end
