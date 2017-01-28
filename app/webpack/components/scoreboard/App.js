import OngoingMatch from './OngoingMatch'
import MatchPreview from './MatchPreview'
import MatchResult from './MatchResult'
import NoMatch from './NoMatch'

export default (props) => (
  <div className="scoreboard">
    <OngoingMatch/>
    <MatchPreview/>
    <MatchResult/>
    <NoMatch/>
  </div>
)
