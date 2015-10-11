defmodule Chop.GameTest do
  use Chop.ModelCase

  alias Chop.Game
  alias Chop.Player
  alias Chop.Point

  @valid_attrs %{}
  @invalid_attrs %{first_service: 5}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end

  test ".service_info" do
    home_player = Repo.insert! %Player{name: "Waldo"}
    away_player = Repo.insert! %Player{name: "Carmen Sandiego"}
    game = Repo.insert! %Game{
      home_player_id: home_player.id,
      away_player_id: away_player.id,
    }
    assert Game.service_info(game) == nil
    game = Repo.update! %Game{game|first_service: 1}
    assert Game.service_info(game) == {:home_player, 1}
    Repo.insert! %Point{match_id: game.id, victor_id: home_player.id}
    assert Game.service_info(game) == {:home_player, 2}
    Repo.insert! %Point{match_id: game.id, victor_id: away_player.id}
    assert Game.service_info(game) == {:away_player, 1}
    Repo.insert! %Point{match_id: game.id, victor_id: home_player.id}
    assert Game.service_info(game) == {:away_player, 2}
    Repo.insert! %Point{match_id: game.id, victor_id: away_player.id}
    # Move score to 10-10.
    Enum.each(1..8, fn (n) ->
      Repo.insert! %Point{match_id: game.id, victor_id: home_player.id}
      Repo.insert! %Point{match_id: game.id, victor_id: away_player.id}
    end)
    assert Game.service_info(game) == {:home_player, 1}
    Repo.insert! %Point{match_id: game.id, victor_id: away_player.id}
    assert Game.service_info(game) == {:away_player, 1}
    Repo.insert! %Point{match_id: game.id, victor_id: away_player.id}
    # FIXME: Perhaps this should be nil as the game is over.
    assert Game.service_info(game) == {:home_player, 1}
  end
end
