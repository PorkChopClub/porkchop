Bacon.Observable::ajax = ->
  @flatMapLatest (params) ->
    Bacon.fromPromise $.ajax(params)
