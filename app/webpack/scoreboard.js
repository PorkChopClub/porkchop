import './banner'

import { render } from 'react-dom'
import { Provider } from 'react-redux'

import store from './stores/scoreboard'
import { trackOngoingMatch } from './actions/ongoingMatch'
import App from './components/scoreboard/App'

const tableId = document.body.dataset.tableId
store.dispatch(trackOngoingMatch(tableId))

render(
  <Provider store={store}>
    <App tableId={tableId}/>
  </Provider>,
  document.getElementById('scoreboard')
)
