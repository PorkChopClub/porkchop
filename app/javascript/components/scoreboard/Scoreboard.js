import { connect } from 'react-redux'

import OngoingMatch from './OngoingMatch'
import MatchPreview from './MatchPreview'
import MatchResult from './MatchResult'
import NoMatch from './NoMatch'

import {
  ongoingMatch,
  secondsOld,
  isMatchHappening,
  isMatchStarted
} from '../../selectors/ongoingMatch'

const mapStateToProps = (state) => {
  return {
    isMatchHappening: isMatchHappening(state),
    secondsOld: secondsOld(state),
    ongoingMatch: ongoingMatch(state),
    isMatchStarted: isMatchStarted(state)
  }
}

const visibleComponent = (props) => {
  const {
    isMatchHappening,
    secondsOld,
    ongoingMatch,
    isMatchStarted
  } = props
  if (!isMatchHappening) { return <NoMatch/> }

  if (!isMatchStarted && secondsOld < 90) {
    return <MatchPreview/>
  }

  return <OngoingMatch match={ongoingMatch}/>
}

const nextMatchPlayers = (match) => match && match.next_matchup.player_names
const nextUpText = (players) => players.length ? `Next up: ${players.join(" vs ")}` : "No upcoming match."

const Scoreboard = (props) => {
  const players = nextMatchPlayers(props.ongoingMatch)

  return (
    <div className="scoreboard">
      {visibleComponent(props)}

      <div className="ongoing-match-next-match">
        {nextUpText(players)}
      </div>
    </div>
  )
}

export default connect(mapStateToProps)(Scoreboard)
