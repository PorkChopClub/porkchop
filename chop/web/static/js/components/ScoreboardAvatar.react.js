let React = require("react");

let ScoreboardAvatar = module.exports = React.createClass({
  classes() {
    return React.addons.classSet({
      "scoreboard-player-avatar": true,
      "has-service": this.props.hasService
    });
  },

  styles() {
    return { backgroundImage: `url(${this.props.avatarUrl})` };
  },

  render() {
    return (
      <div className={this.classes()} style={this.styles()} />
    );
  }
});


