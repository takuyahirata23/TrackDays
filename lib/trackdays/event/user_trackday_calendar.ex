defmodule Trackdays.Event.UserTrackdayCalendar do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_trackday_calendar" do
    field :calendar_id, :string
    field :event_id, :string

    belongs_to :user, Trackdays.Accounts.User
    belongs_to :trackday, Trackdays.Event.Trackday

    timestamps()
  end

  def changeset(user_trackday_calendar, attrs \\ %{}) do
    user_trackday_calendar
    |> cast(attrs, [:calendar_id, :event_id, :user_id, :trackday_id])
    |> validate_required([:calendar_id, :event_id, :user_id, :trackday_id])
    |> unique_constraint([:user_id, :trackday_id, :calendar_id],
      name: :user_trackday_calendar_constraint,
      message: "You added this event already"
    )
  end
end
