import { handleActions } from 'redux-actions';

const defaultState = []

export default handleActions({
  MATCH_UPDATE: (state, { payload }) => {
    const newState = state.filter((match) => (match.id !== payload.id))
    console.log(newState)
    newState.push(payload)
    return newState
  }
}, defaultState)
