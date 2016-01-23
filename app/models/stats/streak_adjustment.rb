module Stats
  class StreakAdjustment
    def initialize(player:, match_result:)
      @player = player
      @match_result = match_result
    end

    def adjust!
      if current_streak_type
        if current_streak_type == match_result
          continue_streak!
        else
          end_streak!
        end
      else
        start_new_streak!
      end
    end

    private

    attr_reader :player, :match_result

    def current_streak_type
      player.current_streak.streak_type if player.current_streak
    end

    def end_streak!
      player.current_streak.update_attributes(finished_at: Time.current)
      start_new_streak!
    end

    def start_new_streak!
      Stats::Streak.create(
        player: player,
        streak_length: 1,
        streak_type: match_result
      )
    end

    def continue_streak!
      Stats::Streak.increment_counter :streak_length, player.current_streak
    end
  end
end
