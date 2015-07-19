Bacon.ajaxPoll = (ajaxOptions, interval) ->
  requests = new Bacon.Bus()
  responses = requests.ajax()

  # initial value
  requests.plug(Bacon.once(ajaxOptions))

  # polling: send a request interval ms after each response
  requests.plug(responses.mapError().delay(interval).map(-> ajaxOptions))

  responses
