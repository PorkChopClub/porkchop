export default function sortPlayers(players) {
  return players.sort(({name: a}, {name: b}) => a.localeCompare(b));
}
