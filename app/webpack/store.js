import { createStore, applyMiddleware, combineReducers, compose } from 'redux'
import thunk from 'redux-thunk'

import reducers from './reducers'

// Enable Chrome Redux DevTools extension if available
const enableDevTools =
  window.devToolsExtension ? window.devToolsExtension() : f => f

export default compose(
  applyMiddleware(thunk),
  enableDevTools
)(createStore)(combineReducers(reducers))
