class Achievement < ActiveRecord::Base
  include Achievements::Dsl

  belongs_to :player

  achievements do
    achievement :victories do
      condition do |player|
        player.victories.size >= 1
      end
    end
  end

  def self.unearned(player)
    earned_varieties = Achievement.where(player_id: player.id).pluck(:variety)
    (varieties - earned_varieties).map do |variety|
      self.new(variety: variety)
    end
  end

  def display_name
    I18n.t rank, scope: [:achievements, variety]
  end
end
