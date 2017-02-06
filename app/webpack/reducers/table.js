import { handleActions } from 'redux-actions'

import {
  setTableId,
  startMatchSetup,
  finishMatchSetup,
  setActivePlayers,
  setTrackingInterval
} from '../actions/table'

export default handleActions({
  [setTableId]: (state, { payload: tableId }) => ({ ...state, isMatchmaking: false, id: tableId }),
  [startMatchSetup]: (state, action) => ({ ...state, isMatchmaking: true }),
  [finishMatchSetup]: (state, action) => ({ ...state, isMatchmaking: false }),
  [setActivePlayers]: (state, { payload: activePlayers }) => ({ ...state, activePlayers }),
  [setTrackingInterval]: (state, { payload: trackingInterval }) => ({ ...state, trackingInterval })
}, {
  id: null,
  isMatchmaking: false,
  activePlayers: [],
  trackingInterval: null
})
