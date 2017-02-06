import { createAction } from 'redux-actions'

import { players } from '../api/v2/players'

export const setPlayers = createAction('PLAYERS_SET')

export const trackPlayers = () => (dispatch) => {
  const refreshPlayers = () => {
    players()
      .then((json) => setPlayers(json))
      .then((event) => dispatch(event))
  }
  refreshPlayers()
  setInterval(refreshPlayers, 60 * 1000)
}
