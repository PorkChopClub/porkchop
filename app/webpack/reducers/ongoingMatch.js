import { handleActions } from 'redux-actions'

import {
  matchUpdated
} from '../actions/ongoingMatch'

export default handleActions({
  [matchUpdated]: (state, action) => action.payload
}, null)
