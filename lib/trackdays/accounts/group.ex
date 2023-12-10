defmodule Trackdays.Accounts.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackdays.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "groups" do
    field :name, :string

    has_many :users, User

    timestamps()
  end

  def changeset(group, attrs \\ %{}) do
    group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
