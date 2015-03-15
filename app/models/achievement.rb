class Achievement < ActiveRecord::Base
  belongs_to :player

  def self.varieties
    Badger.varieties
  end

  def self.unearned(player)
    earned_varieties = Achievement.where(player_id: player.id).pluck(:variety)
    (varieties - earned_varieties).map do |variety|
      new(variety: variety, player: player)
    end
  end

  def display_name
    I18n.t rank, scope: [:achievements, variety]
  end

  def adjust_rank!
    update! rank: Badger.determine_rank(variety, player: player)
  end

  def earned?
    Badger.earned? variety, player: player
  end
end
