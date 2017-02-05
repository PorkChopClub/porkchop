import { handleActions } from 'redux-actions'

import {
  setTableId,
  startMatchSetup,
  finishMatchSetup
} from '../actions/table'

export default handleActions({
  [setTableId]: (state, { payload: tableId }) => ({ ...state, isMatchmaking: false, id: tableId }),
  [startMatchSetup]: (state, action) => ({ ...state, isMatchmaking: true }),
  [finishMatchSetup]: (state, action) => ({ ...state, isMatchmaking: false })
}, {
  id: null,
  isMatchmaking: false
})
