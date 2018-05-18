import createStore from '../utils/createStore'

import ongoingMatch from '../reducers/ongoingMatch'
import table from '../reducers/table'
import players from '../reducers/players'
import connection from '../reducers/connection'

export default createStore({
  ongoingMatch,
  table,
  players,
  connection
})
