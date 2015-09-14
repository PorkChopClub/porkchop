let scoreboardGetters = module.exports = {
  homePlayerName: ['ongoingGame', 'home_player_name'],
  awayPlayerName: ['ongoingGame', 'away_player_name'],
  homePlayerScore: ['ongoingGame', 'home_score'],
  awayPlayerScore: ['ongoingGame', 'away_score'],
  homePlayerService: ['ongoingGame', 'home_player_service'],
  awayPlayerService: [
    ['ongoingGame', 'home_player_service'],
    function(homePlayerService) {
      return !homePlayerService;
    }
  ]
};
