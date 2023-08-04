defmodule Trackdays.Event.Trackday do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackdays.Accounts.User
  alias Trackdays.Vehicle.Motorcycle
  alias Trackdays.Park.Track

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "trackdays" do
    field :lap_time, :integer
    field :date, :date
    field :note, :string

    belongs_to :user, User
    belongs_to :motorcycle, Motorcycle
    belongs_to :track, Track

    timestamps()
  end

  def changeset(trackday, attrs \\ %{}) do
    trackday
    |> cast(attrs, [:lap_time, :date, :note, :motorcycle_id, :track_id])
    |> validate_required([:date, :motorcycle_id, :track_id])
    |> validate_number(:lap_time, less_than_or_equal_to: 300_000)
    |> unique_constraint([:user_id, :motorcycle_id, :date],
      name: :trackday_constraint,
      messeage: "Trackday already exists"
    )
  end
end
