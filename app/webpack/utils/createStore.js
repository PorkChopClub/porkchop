import {
  createStore,
  combineReducers,
  compose
} from 'redux';

export default (reducers) => {
  // Enable Chrome Redux DevTools extension if available
  const enableDevTools =
    window.devToolsExtension ? window.devToolsExtension() : f => f;

  return compose(enableDevTools)(createStore)(combineReducers(reducers));
};
