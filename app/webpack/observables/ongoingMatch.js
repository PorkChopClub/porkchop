import cable from '../cable'
import { fromBinder } from 'baconjs'

export default (tableId) => {
  return fromBinder((sink) => {
    cable.subscriptions.create({ channel: 'OngoingMatchChannel', table_id: tableId }, {
      received: (json) => {
        const data = JSON.parse(json)
        sink(data)
      }
    })

    fetch(`/api/v2/tables/${tableId}/matches/ongoing`)
      .then((response) => response.json())
      .then((json) => sink(json))
  })
}
