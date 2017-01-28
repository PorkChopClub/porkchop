import './banner'

import { render } from 'react-dom'
import { Provider } from 'react-redux'

import store from './stores/scoreboard'
import App from './components/scoreboard/App'

render(
  <Provider store={store}>
    <App/>
  </Provider>,
  document.getElementById('scoreboard')
)
