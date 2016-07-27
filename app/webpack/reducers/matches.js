import { handleActions } from 'redux-actions';

const defaultState = {}

export default handleActions({
  MATCH_UPDATE: (state, { payload }) => {
    const newState = { ...state }
    newState[payload.id] = payload
    return newState
  }
}, defaultState)
