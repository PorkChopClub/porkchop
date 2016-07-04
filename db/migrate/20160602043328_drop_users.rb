class DropUsers < ActiveRecord::Migration[5.0]
  def up
    drop_table "users"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Yeah no that's not going to work."
  end
end
