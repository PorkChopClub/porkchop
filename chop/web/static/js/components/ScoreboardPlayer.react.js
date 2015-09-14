let React = require("react");

let ScoreboardPlayer = module.exports = React.createClass({
  render() {
    return (
      <div className="scoreboard-player">
        {this.props.hasService ? <span>*</span> : null}
        <span className="scoreboard-player-name">{this.props.playerName}</span>:
        <span className="scoreboard-player-score">{this.props.playerScore}</span>
      </div>
    );
  }
});


