defmodule Chop.OngoingGame do
  import Ecto.Query

  alias Chop.Repo
  alias Chop.Game
  alias Chop.Player

  def update! do
    case ongoing_game do
      nil ->
        Chop.Endpoint.broadcast!("games:ongoing", "no_game", %{body: %{}})
      game = %Game{
        id: id,
        home_player: %Player{
          id: home_player_id,
          name: home_player_name,
          nickname: home_player_nickname
        },
        away_player: %Player{
          id: away_player_id,
          name: away_player_name,
          nickname: away_player_nickname
        },
        points: points,
        first_service: first_service
      } ->
        # FIXME: Much of the knowledge encoded here should be extracted into
        # the Chop.Game module.
        Chop.Endpoint.broadcast!("games:ongoing", "update", %{
          body: %{
            id: id,
            firstService: case first_service do
              nil -> nil
              1 -> :home
              2 -> :away
            end,
            home: %{
              name: home_player_nickname || home_player_name,
              score: points |> Enum.count(fn
                p -> p.victor_id == home_player_id
              end)
            },
            away: %{
              name: away_player_nickname || away_player_name,
              score: points |> Enum.count(fn
                p -> p.victor_id == away_player_id
              end)
            }
          }
        })
    end
  end

  defp ongoing_game do
    from(g in Game,
    where: is_nil(g.finalized_at),
    select: g,
    limit: 1,
    preload: [:home_player,
              :away_player,
              :points])
    |> Repo.one
  end
end
