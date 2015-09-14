let { Store, toImmutable } = require("nuclear-js");

let { GAME_UPDATE } = require("../constants");

let ongoingGameStore = module.exports = Store({
  getInitialState() { return toImmutable({}); },
  initialize() { this.on(GAME_UPDATE, updateGameState); }
});

function updateGameState(_oldState, newState) {
  return newState;
}
