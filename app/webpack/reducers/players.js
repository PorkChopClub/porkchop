import { handleActions } from 'redux-actions'
import { sortBy } from 'lodash'

import { setPlayers } from '../actions/players'

export default handleActions({
  [setPlayers]: (state, { payload: players }) => {
    return sortBy(players, ({ name }) => name)
  }
}, [])
