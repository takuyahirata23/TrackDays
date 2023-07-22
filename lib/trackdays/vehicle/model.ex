defmodule Trackdays.Vehicle.Model do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackdays.Vehicle.Make

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "models" do
    field :name, :string

    belongs_to :make, Make

    timestamps()
  end

  def changeset(model, attrs \\ %{}) do
    model
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 30)
    |> unique_constraint([:name, :make_id], message: "#{attrs["name"]} already exists")
  end
end
