defmodule Trackdays.Event do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Event.Trackday

  use Timex

  def save_trackday(attrs, user) do
    %Trackday{}
    |> Trackday.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_trackday_note(attrs) do
    case get_trackday_by_trackday_id(attrs.id) do
      %Trackday{} = trackday ->
        attrs = Map.drop(attrs, [:id])

        changeset = Ecto.Changeset.change(trackday, attrs)
        Repo.update(changeset)

      _ ->
        {:error, nil}
    end
  end

  def get_trackdays_by_user_id(id) when is_binary(id) do
    Repo.all(from t in Trackday, where: t.user_id == ^id)
  end

  def get_trackday_by_month(id, %{year: year, month: month}) when is_binary(id) do
    start = Timex.beginning_of_month(year, month)
    last = Timex.end_of_month(year, month)
    Repo.all(from t in Trackday, where: t.user_id == ^id and t.date <= ^last and t.date >= ^start)
  end

  # TODO: users cannot query other's trackday notes but checking user id is safer just in case
  def get_trackday_by_trackday_id(id) when is_binary(id) do
    Repo.one(from t in Trackday, where: t.id == ^id)
  end

  def get_best_lap_for_each_track(id) when is_binary(id) do
    Repo.all(
      from t in Trackday,
        where: t.user_id == ^id,
        distinct: t.track_id,
        order_by: t.lap_time
    )
  end

  def delete_trackday(trackday_id, user_id) when is_binary(trackday_id) and is_binary(user_id) do
    case Repo.one(from t in Trackday, where: t.id == ^trackday_id and t.user_id == ^user_id) do
      %Trackday{} = trackday ->
        Repo.delete(trackday)

      _ ->
        {:error, %{message: "Trackday not found"}}
    end
  end
end
