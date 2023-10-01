defmodule Trackdays.Event do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Event.Trackday
  alias Trackdays.Park.Track

  use Timex

  def save_trackday(attrs, user) do
    %Trackday{}
    |> Trackday.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def get_trackdays_by_user_id(id) when is_binary(id) do
    Repo.all(from t in Trackday, where: t.user_id == ^id)
  end

  def get_trackday_by_month(id, %{year: year, month: month}) when is_binary(id) do
    start = Timex.beginning_of_month(year, month)
    last = Timex.end_of_month(year, month)
    Repo.all(from t in Trackday, where: t.user_id == ^id and t.date <= ^last and t.date >= ^start)
  end

  def get_trackday_by_trackday_id(id) when is_binary(id) do
    Repo.one(from t in Trackday, where: t.id == ^id)
  end

  def get_best_lap_time_for_tracks(id) when is_binary(id) do
    Repo.all(
      from t in Trackday,
        where: t.user_id == ^id,
        distinct: t.track_id,
        order_by: t.lap_time
    )
  end
end
