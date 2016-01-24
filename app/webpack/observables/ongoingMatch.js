import { ajaxPoll } from 'baconjs';

const EMPTY_MATCH = {
  home_score: "",
  away_score: "",
  home_player_name: "",
  away_player_name: "",
  home_player_nickname: "",
  away_player_nickname: "",
  home_player_service: false,
  away_player_service: false,
  comment: "",
  instructions: ""
};

let ajaxOptions = { url: '/api/ongoing_match.json' };
let matchPolls = ajaxPoll(ajaxOptions, 300);

module.exports = matchPolls
  .map(".match")
  .mapError(EMPTY_MATCH)
  .toProperty();
