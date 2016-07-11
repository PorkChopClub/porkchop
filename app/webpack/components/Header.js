import { h, Component } from 'preact'
import { bind } from 'decko'
import classnames from 'classnames'

class Header extends Component {
  render() {
    return (
      <div className={ this.state.controlsOpen ? "controls-open" : "" }>
        <div className="main-header-wrap">
          <header className="main-header">
            <h1 className="site-title">
              <a href="/">PorkChop<span>.club</span></a>
            </h1>
            <div className="main-header-paddle" />
            <div className={ this.buttonClasses() } onClick={ this.toggleControls }/>
          </header>
        </div>
        <div className="header-controls-wrap">
          <div className="header-controls">
            <ul className="site-navigation">
              <li>
                <a href="/scoreboard/edit">Match Controls</a>
              </li>
              <li>
                <a href="/players">Player List</a>
              </li>
              <li>
                <a href="/matches">Match History</a>
              </li>
              <li>
                <a href="/players/sign_out" data-method="delete">Sign Out</a>
              </li>
              <li>
                <a href="/players/sign_in">Sign In</a>
              </li>
              <li>
                <a href="/players/sign_up">Sign Up</a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    )
  }

  @bind
  toggleControls(e) {
    this.setState({ controlsOpen: !this.state.controlsOpen })
  }

  containerClasses() {
    return classnames({
      "controls-open": this.state.controlsOpen
    })
  }

  buttonClasses() {
    return classnames({
      "main-header-menu-button": true,
      "active": this.state.controlsOpen
    })
  }
}

export default Header
