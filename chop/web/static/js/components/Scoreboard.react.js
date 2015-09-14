let React = require("react");

let ScoreboardPlayer = require("./ScoreboardPlayer.react");

let { ReactMixin } = require("../reactors/scoreboardReactor");
let {
  homePlayerName,
  awayPlayerName,
  homePlayerScore,
  awayPlayerScore,
  homePlayerService,
  awayPlayerService
} = require("../getters/scoreboardGetters");

let Scoreboard = module.exports = React.createClass({
  mixins: [ReactMixin],

  getDataBindings() {
    return {
      homePlayerName: homePlayerName,
      awayPlayerName: awayPlayerName,
      homePlayerScore: homePlayerScore,
      awayPlayerScore: awayPlayerScore,
      homePlayerService: homePlayerService,
      awayPlayerService: awayPlayerService
    }
  },

  render() {
    return (
      <div className="scoreboard">
        <ScoreboardPlayer playerName={this.state.awayPlayerName}
                          playerScore={this.state.awayPlayerScore}
                          hasService={this.state.awayPlayerService} />
        <ScoreboardPlayer playerName={this.state.homePlayerName}
                          playerScore={this.state.homePlayerScore}
                          hasService={this.state.homePlayerService} />
      </div>
    );
  }
});
