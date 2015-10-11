let React = require("react");

let ScoreboardPlayer = require("./ScoreboardPlayer.react");
let ScoreboardAvatar = require("./ScoreboardAvatar.react");

let { ReactMixin } = require("../reactors/scoreboardReactor");
let {
  homePlayerName,
  homePlayerScore,
  homePlayerService,
  homePlayerAvatarUrl,
  awayPlayerName,
  awayPlayerScore,
  awayPlayerService,
  awayPlayerAvatarUrl
} = require("../getters/scoreboardGetters");

let Scoreboard = module.exports = React.createClass({
  mixins: [ReactMixin],

  getDataBindings() {
    return {
      homePlayerName: homePlayerName,
      homePlayerScore: homePlayerScore,
      homePlayerService: homePlayerService,
      homePlayerAvatarUrl: homePlayerAvatarUrl,

      awayPlayerName: awayPlayerName,
      awayPlayerScore: awayPlayerScore,
      awayPlayerService: awayPlayerService,
      awayPlayerAvatarUrl: awayPlayerAvatarUrl
    }
  },

  render() {
    return (
      <div className="scoreboard">
        <div className="scoreboard-player-avatars">
          <ScoreboardAvatar avatarUrl={this.state.awayPlayerAvatarUrl}
                            hasService={!!this.state.awayPlayerService} />
          <ScoreboardAvatar avatarUrl={this.state.homePlayerAvatarUrl}
                            hasService={!!this.state.homePlayerService} />
        </div>
        <div className="scoreboard-players">
          <ScoreboardPlayer playerName={this.state.awayPlayerName}
                            playerScore={this.state.awayPlayerScore}
                            serviceCount={this.state.awayPlayerService} />
          <ScoreboardPlayer playerName={this.state.homePlayerName}
                            playerScore={this.state.homePlayerScore}
                            serviceCount={this.state.homePlayerService} />
        </div>
      </div>
    );
  }
});
