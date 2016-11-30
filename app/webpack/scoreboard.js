import ongoingMatch from './observables/ongoingMatch'
import {
  homeScore,
  awayScore
} from './observables/match'

const tableId = document.body.dataset.tableId;

const match = ongoingMatch(tableId)

homeScore(match).log()
awayScore(match).log()
