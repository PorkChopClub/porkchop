defmodule Chop.OngoingGame do
  @derive [Access]
  defstruct id: nil,
            home: nil,
            away: nil

  import Ecto.Query

  alias Chop.Repo
  alias Chop.Game
  alias Chop.Player

  def fetch do
    case ongoing_game do
      nil -> nil
      game = %Game{
        id: id,
        home_player: home_player,
        away_player: away_player
      } ->
        %__MODULE__{
          id: id,
          home: player_payload(game, :home_player),
          away: player_payload(game, :away_player)
        }
    end
  end

  defp player_payload(game, player_position) do
    player = Map.fetch!(game, player_position)
    %{
      name: Player.display_name(player),
      score: case player_position do
        :home_player -> Game.home_score(game)
        :away_player -> Game.away_score(game)
      end,
      service: case Game.service_info(game) do
        {^player_position, count} -> count
        _ -> nil
      end
    }
  end

  defp ongoing_game do
    from(g in Game,
    where: is_nil(g.finalized_at),
    select: g,
    limit: 1,
    preload: [:home_player, :away_player])
    |> Repo.one
  end
end
