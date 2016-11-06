namespace :porkchop do
  namespace :slack do
    desc "Notify the Slack channel that it's a good time to hop in the queue."
    task put_me_in: [:environment] do
      SlackPutMeInJob.perform_later
    end
  end
end
