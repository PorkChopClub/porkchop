class AddFinalizedAtIndexToMatches < ActiveRecord::Migration
  def change
    add_index :matches, :finalized_at
  end
end
