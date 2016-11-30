# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class OngoingMatchChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ongoing_match_#{params[:table_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  class << self
    def broadcast_update(table: Table.default)
      return unless table
      json = payload_json(table.ongoing_match)
      ActionCable.server.broadcast "ongoing_match_#{table.id}", json
    end

    private

    def payload_json(match)
      if match
        options = {
          include: [:home_player, :away_player]
        }
        ActiveModelSerializers::SerializableResource.new(match, options).to_json
      else
        nil.to_json
      end
    end
  end
end
