defmodule Chop.Point do
  use Chop.Web, :model

  import Chop.Game
  import Chop.Player

  schema "points" do
    belongs_to :game, Game, foreign_key: :match_id
    belongs_to :winner, Player, foreign_key: :victor_id
    timestamps inserted_at: :created_at
  end

  @required_fields ~w(match_id victor_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
