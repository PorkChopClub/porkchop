let { toImmutable } = require("nuclear-js");

let scoreboardReactor = require("../reactors/scoreboardReactor");
let { GAME_UPDATE } = require("../constants");

let scoreboardActions = module.exports = {
  updateGame(newGameState) {
    scoreboardReactor.dispatch(
      GAME_UPDATE,
      toImmutable(newGameState)
    );
  }
};
