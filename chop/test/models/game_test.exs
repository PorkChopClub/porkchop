defmodule Chop.GameTest do
  use Chop.ModelCase

  alias Chop.Game

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
end
