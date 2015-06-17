class PorkChop.MatchStream
  @polling: (interval) ->
    ajaxOptions = { url: '/api/ongoing_match.json' }
    matchPolls = Bacon.mergeAll([Bacon.interval(interval, ajaxOptions),
                                 Bacon.once(ajaxOptions)]).ajax()

    match = matchPolls
      .map(".match")
      .mapError -> {
        home_score: "",
        away_score: "",
        home_player_name: "",
        away_player_name: "",
        home_player_service: false,
        away_player_service: false,
        comment: "",
        instructions: ""
      }
      .toProperty()

    new @ match

  constructor: (match) ->
    match = match.skipDuplicates(_.isEqual)
    @match = match

    @id = match.map(".id")

    @homeScore = match.map(".home_score")
    @awayScore = match.map(".away_score")

    @homePlayerName = match.map(".home_player_name")
    @awayPlayerName = match.map(".away_player_name")
    @homePlayerNickname = match.map(".home_player_nickname")
    @awayPlayerNickname = match.map(".away_player_nickname")

    @homePlayerDisplayName = @homePlayerNickname.or(@homePlayerName)
    @awayPlayerDisplayName = @awayPlayerNickname.or(@awayPlayerName)

    @homePlayerService = match.map(".home_player_service")
    @awayPlayerService = match.map(".away_player_service")

    @homePlayerAvatarUrl = match.map(".home_player_avatar_url").skipDuplicates()
    @awayPlayerAvatarUrl = match.map(".away_player_avatar_url").skipDuplicates()

    @comment = match.map(".comment")
    @commentPresent = @comment.not().not()

    @instructions = match.map(".instructions")
    @commentPresent = @comment.not().not()

    @finished = match.map(".finished")
    @finalized = match.map(".finalized")
    @deleted = match.map(".deleted").toProperty()
    @league_match = match.map(".league_match")
