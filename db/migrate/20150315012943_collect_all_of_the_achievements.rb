class CollectAllOfTheAchievements < ActiveRecord::Migration
  def up
    Player.find_each do |player|
      player.all_achievements.select(&:earned?).each(&:adjust_rank!)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
