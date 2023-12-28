defmodule Trackdays.Vehicle.Motorcycle do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackdays.Event.TrackdayNote

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "motorcycles" do
    field :year, :integer
    field :is_archived, :boolean

    has_many :trackday_notes, TrackdayNote

    belongs_to :model, Trackdays.Vehicle.Model
    belongs_to :user, Trackdays.Accounts.User

    timestamps()
  end

  def changeset(motorcycle, attrs \\ %{}) do
    motorcycle
    |> cast(attrs, [:year, :model_id, :user_id, :is_archived])
    |> validate_required([:year, :model_id, :user_id])
    |> validate_number(:year,
      greater_than: 1800,
      less_than_or_equal_to: DateTime.utc_now() |> Map.fetch!(:year)
    )
    |> unique_constraint([:user_id, :model_id, :year],
      name: :motorcycle_constraint,
      message: "Already registered"
    )
  end
end
