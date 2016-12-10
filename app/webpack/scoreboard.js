import $ from 'jquery'

import scoreboardTemplate from './templates/scoreboard.hbs'
import ongoingMatch from './observables/ongoingMatch'
import ongoingMatchComponent from './components/ongoingMatchComponent'

const tableId = document.body.dataset.tableId;
const match = ongoingMatch(tableId)

$(document.body).html(scoreboardTemplate())

match.log()
ongoingMatchComponent($('.scoreboard-ongoing-match'), match)
