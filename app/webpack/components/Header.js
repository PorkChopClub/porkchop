import { h, Component } from 'preact'
import { bind } from 'decko'
import classnames from 'classnames'

class Header extends Component {
  render() {
    return (
      <div>
        <div className="main-header-wrap">
          <header className="main-header">
            <h1 className="site-title">
              <a href="/">PorkChop<span>.club</span></a>
            </h1>
            <div className="main-header-paddle" />
            <div className={this.buttonClasses()} onClick={this.toggleControls}/>
          </header>
        </div>
        {this.headerControls()}
      </div>
    )
  }

  @bind
  toggleControls(e) {
    this.setState({ controlsOpen: !this.state.controlsOpen })
  }

  buttonClasses() {
    return classnames({
      "main-header-menu-button": true,
      "active": this.state.controlsOpen
    })
  }

  headerControls() {
    if (this.state.controlsOpen) {
      return (
        <div className="header-controls-wrap">
          <div className="header-controls">
            <ul className="site-navigation">
              {this.matchControls()}
              <li>
                <a href="/players">Player List</a>
              </li>
              <li>
                <a href="/matches">Match History</a>
              </li>
              {this.sessionControls()}
            </ul>
          </div>
        </div>
      )
    }
  }

  matchControls() {
    if (this.props.showControls) {
      return <li><a href="/scoreboard/edit">Match Controls</a></li>
    }
  }

  sessionControls() {
    if (this.props.loggedIn) {
      return <li><a href="/players/sign_out" data-method="delete">Sign Out</a></li>
    }
    return [
      <li>
        <a href="/players/sign_in">Sign In</a>
      </li>,
      <li>
        <a href="/players/sign_up">Sign Up</a>
      </li>
    ]
  }
}

export default Header
