import { handleActions } from 'redux-actions'

import {
  ongoingMatchDisconnected,
  ongoingMatchConnected
} from '../actions/ongoingMatch'

export default handleActions({
  [ongoingMatchDisconnected]: (state, action) => ({ connected: false }),
  [ongoingMatchConnected]: (state, action) => ({ connected: true }),
}, { connected: false })
