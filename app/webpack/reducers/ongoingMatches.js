import { handleActions } from 'redux-actions';

const defaultState = {
  matches: {}
}

export default handleActions({
  MATCH_UPDATE: (state, { payload }) => {
    const matches = { ...state.matches }
    matches[payload.id] = payload
    return { ...state, matches: matches }
  }
}, defaultState)
