let React = require("react/addons");

let ScoreboardServiceMessage = require("./ScoreboardServiceMessage.react")

let ScoreboardPlayer = module.exports = React.createClass({
  classes() {
    return React.addons.classSet({
      "scoreboard-player": true,
      "has-service": this.hasService()
    });
  },

  hasService() {
    return !!this.props.serviceCount;
  },

  serviceMessageComponent() {
    if (this.hasService()) {
      return (
        <ScoreboardServiceMessage serviceCount={this.props.serviceCount} />
      );
    }
  },

  render() {
    return (
      <div className={this.classes()}>
        <div className="scoreboard-player-score">{this.props.playerScore}</div>
        <div className="scoreboard-player-name-wrap">
          <div className="scoreboard-player-name">
            {this.props.playerName}
          </div>
        </div>
        {this.serviceMessageComponent()}
      </div>
    );
  }
});


