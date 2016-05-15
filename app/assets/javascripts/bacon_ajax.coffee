Bacon.Observable::ajax = ->
  @flatMap (params) ->
    Bacon.fromPromise $.ajax(params)

Bacon.Observable::serialAjax = ->
  @flatMapConcat (params) ->
    Bacon.fromPromise $.ajax(params)
