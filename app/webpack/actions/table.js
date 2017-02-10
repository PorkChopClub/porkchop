import { createAction } from 'redux-actions'

import { setup } from '../api/v2/ongoingMatch'
import {
  activePlayers,
  activatePlayer as apiActivatePlayer,
  deactivatePlayer as apiDeactivatePlayer} from '../api/v2/table'

import {
  tableId as tableIdSelector,
  trackingInterval,
  activePlayers as activePlayersSelector
} from '../selectors/table'
import players from '../selectors/players'

export const setTableId = createAction('TABLE_SET_ID')
export const setActivePlayers = createAction('TABLE_SET_ACTIVE_PLAYERS')
export const startMatchSetup = createAction('TABLE_MATCH_SETUP_START')
export const finishMatchSetup = createAction('TABLE_MATCH_SETUP_FINISH')
export const setTrackingInterval = createAction('TABLE_SET_TRACKING_INTERVAL')

export const activatePlayer = ({ tableId, playerId }) => (dispatch, getState) => {
  const activePlayers = activePlayersSelector(getState())
  const activatedPlayer = players(getState()).find((player) => player.id === playerId)

  dispatch(setActivePlayers([activatedPlayer, ...activePlayers]))
  apiActivatePlayer({ tableId, playerId })
    .then((json) => dispatch(setActivePlayers(json)))
}

export const deactivatePlayer = ({ tableId, playerId }) => (dispatch, getState) => {
  const activePlayers = activePlayersSelector(getState()).filter((player) => player.id !== playerId)
  dispatch(setActivePlayers(activePlayers))
  apiDeactivatePlayer({ tableId, playerId })
    .then((json) => dispatch(setActivePlayers(json)))
}

export const matchmake = (tableId) => (dispatch, getState) => {
  dispatch(startMatchSetup())
  setup(tableId).then((json) => { dispatch(finishMatchSetup()) })
}

export const trackTable = (tableId) => (dispatch, getState) => {
  const refreshPlayers = (tableId) => {
    activePlayers(tableId)
      .then((json) => setActivePlayers(json))
      .then((event) => dispatch(event))
  }

  dispatch(setTableId(tableId))
  refreshPlayers(tableId)

  let interval = trackingInterval(getState())

  if (interval) { return }

  interval = setInterval(() => {
    const tableId = tableIdSelector(getState())
    if (tableId) { refreshPlayers(tableId) }
  }, 10*1000)

  dispatch(setTrackingInterval(interval))
}
