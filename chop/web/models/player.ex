defmodule Chop.Player do
  use Chop.Web, :model

 schema "players" do
    field :name, :string
    field :nickname, :string
    field :avatar_url, :string
    field :active, :boolean
    timestamps inserted_at: :created_at
  end

  @required_fields ~w(name)
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
