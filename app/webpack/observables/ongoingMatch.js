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
  home_player_overlays: {flames: false},
  away_player_overlays: {flames: false},
  comment: "",
  instructions: "Waiting for players",
  league_match: false,
  warmup: false
};

let ajaxOptions = { url: '/api/ongoing_match.json' };
let matchPolls = ajaxPoll(ajaxOptions, 300);

export default matchPolls
  .map(".match")
  .mapError(EMPTY_MATCH)
  .toProperty();
