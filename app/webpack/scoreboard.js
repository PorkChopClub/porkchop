import $ from 'jquery'
import { combineWith } from 'baconjs'

import scoreboardTemplate from './templates/scoreboard.hbs'
import ongoingMatch from './observables/ongoingMatch'
import ongoingMatchComponent from './components/ongoingMatchComponent'
import preMatchComponent from './components/preMatchComponent'
import {
  secondsOld,
  serviceSelected
} from './observables/match'


const tableId = document.body.dataset.tableId
const match = ongoingMatch(tableId)

match.log()

$(document.body).html(scoreboardTemplate())

const newMatch = secondsOld(match).map((n) => n <= 120)
const started = serviceSelected(match)
const noMatch = match.map((match) => !match)

combineWith(
  [newMatch, started, noMatch],
  (newMatch, started, noMatch) => {
    if (noMatch) {
      return 'no-match'
    } else if (newMatch && !started) {
      return 'pre-match'
    } else {
      return 'ongoing-match'
    }
  }
)
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
