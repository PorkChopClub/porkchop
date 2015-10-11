defmodule Chop.OngoingGameTest do
  use ExUnit.Case

  alias Chop.OngoingGame
  alias Chop.Game
  alias Chop.Player
  alias Chop.Repo

  setup _tags do
    Ecto.Adapters.SQL.restart_test_transaction(Repo, [])
    :ok
  end

  test "it is nil when there is no game" do
    Repo.insert! finished_game
    assert nil = OngoingGame.fetch
  end

  test "it returns the ongoing game when there is one" do
    %Game{id: id} = Repo.insert! ongoing_game
    assert %OngoingGame{
      id: ^id,
      home: %{
        name: "Spiderman",
        score: 0,
        service: 1
      },
      away: %{
        name: "Carmen Sandiego",
        score: 0,
        service: nil
      }
    } = OngoingGame.fetch
  end

  defp home_player do
    Repo.insert! %Player{
      name: "Waldo",
      nickname: "Spiderman"
    }
  end

  defp away_player do
    Repo.insert! %Player{name: "Carmen Sandiego"}
  end

  defp finished_game do
    %Game{
      home_player: home_player.id,
      away_player: away_player.id,
      finalized_at: arbitrary_datetime
    }
  end

  defp ongoing_game do
    %Game{
      home_player_id: home_player.id,
      away_player_id: away_player.id,
      first_service: 1
    }
  end

  defp arbitrary_datetime do
    {:ok, datetime} = Ecto.DateTime.cast("2014-04-17T14:00:00Z")
    datetime
  end
end
