import { createAction } from 'redux-actions'

import { setup } from '../api/v2/ongoingMatch'
import { activePlayers } from '../api/v2/table'

import { tableId as tableIdSelector, trackingInterval } from '../selectors/table'

export const setTableId = createAction('TABLE_SET_ID')
export const setActivePlayers = createAction('TABLE_SET_ACTIVE_PLAYERS')
export const startMatchSetup = createAction('TABLE_MATCH_SETUP_START')
export const finishMatchSetup = createAction('TABLE_MATCH_SETUP_FINISH')
export const setTrackingInterval = createAction('TABLE_SET_TRACKING_INTERVAL')

export const matchmake = (tableId) => (dispatch, getState) => {
  dispatch(startMatchSetup())
  setup(tableId).then((json) => {
    console.log(json);
    dispatch(finishMatchSetup())
  })
}

export const trackTable = (tableId) => (dispatch, getState) => {
  dispatch(setTableId(tableId))

  let interval = trackingInterval(getState())

  if (interval) { return }

  interval = setInterval(() => {
    const tableId = tableIdSelector(getState())
    if (!tableId) { return }

    activePlayers(tableId)
      .then((json) => setActivePlayers(json))
      .then((event) => dispatch(event))
  }, 10*1000)

  dispatch(setTrackingInterval(interval))
}
