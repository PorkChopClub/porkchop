import $ from 'jquery'

import scoreboardTemplate from './templates/scoreboard.hbs'
import ongoingMatch from './observables/ongoingMatch'
import {
  homeScore,
  awayScore
} from './observables/match'

const tableId = document.body.dataset.tableId;
const match = ongoingMatch(tableId)

$(document.body).html(scoreboardTemplate())

homeScore(match).log()
awayScore(match).log()
