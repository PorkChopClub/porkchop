import createStore from '../utils/createStore'

import ongoingMatch from '../reducers/ongoingMatch'
import table from '../reducers/table'
import players from '../reducers/players'

export default createStore({
  ongoingMatch,
  table,
  players
})
