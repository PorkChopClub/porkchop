import './banner'

import { render } from 'react-dom'
import { Provider } from 'react-redux'

import cable from './cable'
import store from './stores/scoreboard'
import App from './components/scoreboard/App'

const element = document.getElementById('scoreboard')
const tableId = document.body.dataset.tableId

render(
  <Provider store={store}>
    <App/>
  </Provider>,
  element
)

import { matchUpdated } from './actions/ongoingMatch'

const dispatchMatchUpdate = (match) => store.dispatch(matchUpdated(match))

cable.subscriptions.create({ channel: 'OngoingMatchChannel', table_id: tableId }, {
  received: (json) => {
    const data = JSON.parse(json)
    dispatchMatchUpdate(data)
  }
})

fetch(`/api/v2/tables/${tableId}/matches/ongoing`)
  .then((response) => response.json())
  .then((json) => dispatchMatchUpdate(json))
