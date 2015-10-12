let React = require("react/addons");

let ScoreboardServiceMessage = module.exports = React.createClass({
  serviceMessage() {
    if (this.props.serviceCount === 1) {
      return "First service";
    } else {
      return "Second service";
    }
  },

  render() {
    return (
      <div className="scoreboard-player-service-message">
        {this.serviceMessage()}
      </div>
    );
  }
});
