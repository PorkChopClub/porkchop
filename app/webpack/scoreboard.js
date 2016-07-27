import './shared'

import { h, render } from 'preact'
import { Provider } from 'preact-redux'

import Scoreboard from './components/Scoreboard'
import store from './store'
import { trackTable } from './actions/tables'
import { setTable } from './actions/scoreboard'

render(
  <Provider store={store}>
    <Scoreboard />
  </Provider>,
  document.body
)

const tableId = document.body.dataset.tableId

store.dispatch(trackTable(tableId))
store.dispatch(setTable(tableId))
