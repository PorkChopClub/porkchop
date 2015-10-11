defmodule Chop.Game do
  use Chop.Web, :model

  import Ecto.Query

  alias Chop.Repo
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
    |> validate_inclusion(:first_service, [1, 2])
  end

  def service_info(%__MODULE__{first_service: nil}), do: nil
  def service_info(%__MODULE__{id: game_id, first_service: first_service}) do
    point_count = from(p in Point,
                  where: p.match_id == ^game_id,
                  select: count(p.id))
                  |> Repo.one

    {first_player, second_player} = case first_service do
      1 -> {:home_player, :away_player}
      2 -> {:away_player, :home_player}
    end

    case point_count do
      count when count < 20 and rem(div(count, 2), 2) == 0 ->
        {first_player, rem(count, 2) + 1}
      count when count < 20 ->
        {second_player, rem(count, 2) + 1}
      count when rem(count, 2) == 0 ->
        {first_player, 1}
      count ->
        {second_player, 1}
    end
  end

  def home_score(game = %__MODULE__{home_player_id: id}), do: score(game, id)
  def away_score(game = %__MODULE__{away_player_id: id}), do: score(game, id)

  defp score(%__MODULE__{id: game_id}, player_id) do
    from(p in Point,
    where: p.victor_id == ^player_id,
    where: p.match_id == ^game_id,
    select: count(p.id))
    |> Repo.one
  end
end
