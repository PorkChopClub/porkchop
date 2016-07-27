import './shared'

import { h, render } from 'preact'
import { Provider } from 'preact-redux'

import Scoreboard from './components/Scoreboard'
import store from './store'

render(
  <Provider store={store}>
    <Scoreboard />
  </Provider>,
  document.body
)
