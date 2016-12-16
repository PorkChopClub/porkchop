import $ from 'jquery'

import scoreboardTemplate from './templates/scoreboard.hbs'
import ongoingMatch from './observables/ongoingMatch'
import ongoingMatchComponent from './components/ongoingMatchComponent'
import preMatchComponent from './components/preMatchComponent'

const tableId = document.body.dataset.tableId
const match = ongoingMatch(tableId)

$(document.body).html(scoreboardTemplate())

// FIXME: This is bad Bacon.js code.
match
  .map((match) => {
    if (!match) {
      return 'no-match'
    } else if (match.seconds_old <= 60 && !match.service_selected) {
      return 'pre-match'
    } else {
      return 'ongoing-match'
    }
  })
  .skipDuplicates()
  .scan(
    { currentState: 'no-match' },
    ({ currentState: previousState }, currentState) => ({ currentState, previousState })
  )
  .onValue(({ currentState, previousState }) => {
    $(`.scoreboard-page.scoreboard-${previousState}`).removeClass('active')
    $(`.scoreboard-page.scoreboard-${currentState}`).addClass('active')
  })

ongoingMatchComponent($('.scoreboard-ongoing-match'), match)
preMatchComponent($('.scoreboard-pre-match'), match)
