import './banner'

import { render } from 'react-dom'
import { Provider } from 'react-redux'

import store from './stores/scoreboard'
import { trackOngoingMatch } from './actions/ongoingMatch'
import { trackTable } from './actions/table'
import App from './components/scoreboard/App'

const tableId = document.body.dataset.tableId
store.dispatch(trackTable(tableId))
store.dispatch(trackOngoingMatch(tableId))

render(
  <Provider store={store}>
    <App/>
  </Provider>,
  document.getElementById('scoreboard')
)
