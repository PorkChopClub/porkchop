defmodule Chope.PointTest do
  use Chop.ModelCase

  alias Chop.Point

  @valid_attrs %{match_id: 1, victor_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Point.changeset(%Point{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Point.changeset(%Point{}, @invalid_attrs)
    refute changeset.valid?
  end
end
