defmodule Chop.PlayerTest do
  use Chop.ModelCase

  alias Chop.Player

  @valid_attrs %{name: "Serena Williams"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Player.changeset(%Player{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Player.changeset(%Player{}, @invalid_attrs)
    refute changeset.valid?
  end
end
