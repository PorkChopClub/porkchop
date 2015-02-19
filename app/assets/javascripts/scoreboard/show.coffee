$ ->
  return unless $('.scoreboard').length

  matchPolls = Bacon.interval(1000, { url: '/api/ongoing_match.json' }).ajax()

  match = matchPolls
    .map(".match")
    .mapError -> {
      home_score: "",
      away_score: "",
      home_player_name: "",
      away_player_name: ""
    }

  match.map(".home_score")
    .assign $(".scoreboard-home-player-score"), "text"
  match.map(".away_score")
    .assign $(".scoreboard-away-player-score"), "text"

  match.map(".home_player_name")
    .assign $(".scoreboard-home-player-name"), "text"
  match.map(".away_player_name")
    .assign $(".scoreboard-away-player-name"), "text"
