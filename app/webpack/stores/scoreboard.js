import createStore from '../utils/createStore'

import ongoingMatch from '../reducers/ongoingMatch'
import table from '../reducers/table'

export default createStore({
  ongoingMatch,
  table
})
