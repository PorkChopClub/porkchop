class SlackPutMeInJob < ApplicationJob
  queue_as :default

  def perform
    SlackMessage.new(message).send!
  end

  private

  def message
    ":table_tennis_paddle_and_ball: There's ping pong to play! <http://porkchop.club/play|Click here to join the queue!> :table_tennis_paddle_and_ball:"
  end
end
