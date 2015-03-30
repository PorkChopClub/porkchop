class @AchievementStream
  @polling: (interval) ->
    ajaxOptions = { url: '/api/achievements.json' }

    achievements = Bacon.mergeAll([
      Bacon.interval(interval, ajaxOptions),
      Bacon.once(ajaxOptions)
    ]).ajax().map('.achievements')

    # FIXME: this is some pretty crap logic
    # Works if we don't delete records, but should be replaced with something more robust
    emitChanges = (before, after) ->
      out = []
      for value, index in after
        if !before[index] || !_.isEqual(value, before[index])
          out.push value
      out

    stream = achievements
      .diff({}, emitChanges)
      .skip(1)
      .flatMap(Bacon.fromArray)

    new @ stream

  constructor: (achievements) ->
    @achievements = achievements

  buffered: (interval) ->
    # Receive one achievement at a time at the rate of `interval`
    achievementEvents = @achievements
      .bufferingThrottle(interval)

    # When there are no more achievements pending, emit false
    reset = achievementEvents
      .debounce(interval + 1)
      .map(false)

    achievementEvents.merge(reset)
