import { h, Component } from 'preact'
import { connect } from 'preact-redux'

const mapState = (state) => {
  return {}
}

const Scoreboard = ({ foo }) => {
  return (
    <div>Scoreboard! {foo}</div>
  )
}

export default connect(mapState)(Scoreboard)
