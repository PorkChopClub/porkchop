import $ from 'jquery'

import scoreboardTemplate from './templates/scoreboard.hbs'
import ongoingMatch from './observables/ongoingMatch'
import ongoingMatchComponent from './components/ongoingMatchComponent'

const tableId = document.body.dataset.tableId;
const match = ongoingMatch(tableId)

$(document.body).html(scoreboardTemplate())

match.log()

match
  .map((match) => {
    if (match) {
      return 'ongoing-match'
    } else {
      return 'no-match'
    }
  })
  .skipDuplicates()
  .scan(
    { currentState: 'no-match' },
    ({ currentState: previousState }, currentState) => ({ currentState, previousState })
  )
  .onValue(({ currentState, previousState }) => {
    $(`.scoreboard-page.scoreboard-${previousState}`).removeClass('active');
    $(`.scoreboard-page.scoreboard-${currentState}`).addClass('active');
  })

ongoingMatchComponent($('.scoreboard-ongoing-match'), match)
