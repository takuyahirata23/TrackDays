defmodule Trackdays.Event.TrackdayNote do
  use Ecto.Schema
  import Ecto.Changeset

  alias Trackdays.Accounts.{User, Group}
  alias Trackdays.Vehicle.Motorcycle
  alias Trackdays.Park.Track

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "trackday_notes" do
    field :lap_time, :integer
    field :date, :date
    field :note, Trackdays.Encrypted.Binary

    belongs_to :group, Group
    belongs_to :user, User
    belongs_to :motorcycle, Motorcycle
    belongs_to :track, Track

    timestamps()
  end

  def changeset(trackday_note, attrs \\ %{}) do
    trackday_note
    |> cast(attrs, [:lap_time, :date, :note, :motorcycle_id, :track_id, :group_id])
    |> validate_required([:date, :motorcycle_id, :track_id, :group_id])
    # 5 minutes
    |> validate_number(:lap_time, less_than_or_equal_to: 300_000)
    |> unique_constraint([:user_id, :motorcycle_id, :date],
      name: :trackday_note_constraint,
      message: "Trackday note already exists"
    )
  end
end
