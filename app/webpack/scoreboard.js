import ongoingMatch from './observables/ongoingMatch'

const tableId = document.body.dataset.tableId;

ongoingMatch(tableId).onValue((x) => console.log(x))
