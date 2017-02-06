import { handleActions } from 'redux-actions'

import { setPlayers } from '../actions/players'

export default handleActions({
  [setPlayers]: (state, { payload: players }) => players
}, [])
