defmodule Chop.Game do
  use Chop.Web, :model

  alias Chop.Player
  alias Chop.Point

  schema "matches" do
    belongs_to :home_player, Player
    belongs_to :away_player, Player
    belongs_to :victor, Player
    has_many :points, Point, foreign_key: :match_id
    field :finalized_at, Ecto.DateTime
    field :first_service, :integer
    timestamps inserted_at: :created_at
  end

  @required_fields ~w()
  @optional_fields ~w(finalized_at first_service)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:first_service, [0,1])
  end
end
