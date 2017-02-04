import { handleActions } from 'redux-actions'

import {
  ongoingMatchUpdated
} from '../actions/ongoingMatch'

export default handleActions({
  [ongoingMatchUpdated]: (state, action) => action.payload
}, null)
