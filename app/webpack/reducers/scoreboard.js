import { handleActions } from 'redux-actions';

const defaultState = { table_id: null }

export default handleActions({
  SCOREBOARD_SET_TABLE: (state, { payload }) => ({ ...state, table_id: payload })
}, defaultState)
