let React = require("react");

let Scoreboard = require("./components/Scoreboard.react");

let scoreboardReactor = require("./reactors/scoreboardReactor");
let ongoingGameStore = require("./stores/ongoingGameStore");
let ongoingGameChannel = require("./channels/ongoingGameChannel");
let { updateGame } = require("./actions/scoreboardActions");

scoreboardReactor.registerStores({ ongoingGame: ongoingGameStore });

ongoingGameChannel.join();
ongoingGameChannel.on("update", function(payload) {
  updateGame(payload.body);
});

React.render(<Scoreboard />, document.getElementById("scoreboard"));
