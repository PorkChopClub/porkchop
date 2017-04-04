class CreateTimelineEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :timeline_events do |t|
      t.references :match, foreign_key: true, null: false
      t.references :player, foreign_key: true
      t.string :event_type, null: false

      t.timestamps
    end
  end
end
