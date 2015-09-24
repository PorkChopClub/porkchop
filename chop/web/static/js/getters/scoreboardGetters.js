let currentService = function(player) {
  return function(firstService, homeScore, awayScore) {
    let totalScore = homeScore + awayScore;
    let firstPlayerService =
      (totalScore >= 20 ? totalScore : (totalScore / 2) | 0) % 2 === 0;
    if (firstService !== null) {
      return firstService !== player ? !firstPlayerService : firstPlayerService;
    } else {
      return false;
    }
  };
};

let scoreboardGetters = module.exports = {
  homePlayerName: ['ongoingGame', 'home', 'name'],
  awayPlayerName: ['ongoingGame', 'away', 'name'],
  homePlayerScore: ['ongoingGame', 'home', 'score'],
  awayPlayerScore: ['ongoingGame', 'away', 'score'],
  homePlayerService: [
    ['ongoingGame', 'firstService'],
    ['ongoingGame', 'home', 'score'],
    ['ongoingGame', 'away', 'score'],
    currentService("home")
  ],
  awayPlayerService: [
    ['ongoingGame', 'firstService'],
    ['ongoingGame', 'home', 'score'],
    ['ongoingGame', 'away', 'score'],
    currentService("away")
  ]
};
