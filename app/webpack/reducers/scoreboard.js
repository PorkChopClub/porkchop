import { handleActions } from 'redux-actions'

const defaultState = { tableId: null }

export default handleActions({
  SCOREBOARD_SET_TABLE: (state, { payload }) => ({ ...state, tableId: payload })
}, defaultState)
