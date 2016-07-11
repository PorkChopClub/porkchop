import Bacon from 'baconjs'
import $ from 'jquery'

$.ajaxSetup({
  beforeSend(xhr) {
    const token = $('meta[name="csrf-token"]').attr('content')
    xhr.setRequestHeader('X-CSRF-Token', token)
  },
})

// FIXME: We have a fetch polyfill and should use it.
Bacon.Observable.prototype.ajax = function() {
  return this.flatMapLatest(
    (params) => Bacon.fromPromise($.ajax(params))
  )
}

Bacon.Observable.prototype.serialAjax = function() {
  return this.flatMapConcat(
    (params) => Bacon.fromPromise($.ajax(params))
  )
}

Bacon.ajaxPoll = (ajaxOptions, interval) => {
  const requests = new Bacon.Bus()
  const responses = requests.ajax()

  requests.plug(
    Bacon.once(ajaxOptions)
  )

  requests.plug(
    responses.mapError().delay(interval).map(() => ajaxOptions)
  )

  return responses
}
