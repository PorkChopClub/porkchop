import { handleActions } from 'redux-actions'
import sortPlayers from 'utils/sortPlayers'

import { setPlayers } from '../actions/players'

export default handleActions({
  [setPlayers]: (state, { payload: players }) => {
    return sortPlayers(players)
  }
}, [])
