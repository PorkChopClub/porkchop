import { handleActions } from 'redux-actions'

import {
  ongoingMatchUpdated,
  clockTick
} from '../actions/ongoingMatch'

export default handleActions({
  [ongoingMatchUpdated]: (state, action) => action.payload,
  [clockTick]: (state, action) => {
    if (state === null) { return null }
    return { ...state, seconds_old: state.seconds_old + 1 }
  }
}, null)
