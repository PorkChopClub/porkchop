import {
  createStore,
  combineReducers,
  compose,
  applyMiddleware
} from 'redux';
import thunk from 'redux-thunk'

export default (reducers) => {
  // Enable Chrome Redux DevTools extension if available
  const enableDevTools =
    window.devToolsExtension ? window.devToolsExtension() : f => f;

  // This is awful looking.
  return compose(
    applyMiddleware(thunk),
    enableDevTools
  )(
    createStore
  )(
    combineReducers(reducers)
  );
};
