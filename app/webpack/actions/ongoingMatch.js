import { createAction } from 'redux-actions'

import cable from '../cable'

export const ongoingMatchUpdated = createAction('ONGOING_MATCH_UPDATED')

export const trackOngoingMatch = (tableId) => (dispatch) => {
  const dispatchMatchUpdate = (match) => dispatch(ongoingMatchUpdated(match))

  cable.subscriptions.create({ channel: 'OngoingMatchChannel', table_id: tableId }, {
    received: (json) => {
      const data = JSON.parse(json)
      dispatchMatchUpdate(data)
    }
  })

  fetch(`/api/v2/tables/${tableId}/matches/ongoing`)
    .then((response) => response.json())
    .then((json) => dispatchMatchUpdate(json))
}
