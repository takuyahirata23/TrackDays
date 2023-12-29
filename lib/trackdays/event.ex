defmodule Trackdays.Event do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Event.{TrackdayNote, Trackday, UserTrackdayCalendar}
  alias Trackdays.Park.{Facility, Track}
  alias Trackdays.Accounts.{User}
  alias Trackdays.Vehicle.{Motorcycle, Model, Make}

  use Timex

  def save_trackday_note(attrs, user) do
    %TrackdayNote{}
    |> TrackdayNote.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def update_trackday_note(attrs) do
    case get_trackday_note_by_id(attrs.id) do
      %TrackdayNote{} = trackday ->
        attrs = Map.drop(attrs, [:id])

        changeset = Ecto.Changeset.change(trackday, attrs)
        Repo.update(changeset)

      _ ->
        {:error, nil}
    end
  end

  def get_trackday_notes_by_user_id(id) when is_binary(id) do
    Repo.all(from t in TrackdayNote, where: t.user_id == ^id)
  end

  def get_trackday_notes_by_month(id, %{year: year, month: month}) when is_binary(id) do
    start = Timex.beginning_of_month(year, month)
    last = Timex.end_of_month(year, month)

    Repo.all(
      from t in TrackdayNote, where: t.user_id == ^id and t.date <= ^last and t.date >= ^start
    )
  end

  # TODO: users cannot query other's trackday notes but checking user id is safer just in case
  def get_trackday_note_by_id(id) when is_binary(id) do
    Repo.one(from t in TrackdayNote, where: t.id == ^id)
  end

  def get_best_lap_for_each_track(id) when is_binary(id) do
    Repo.all(
      from t in TrackdayNote,
        where: t.user_id == ^id,
        distinct: t.track_id,
        order_by: t.lap_time
    )
  end

  def delete_trackday_note(trackday_note_id, user_id)
      when is_binary(trackday_note_id) and is_binary(user_id) do
    case Repo.one(
           from t in TrackdayNote, where: t.id == ^trackday_note_id and t.user_id == ^user_id
         ) do
      %TrackdayNote{} = trackday_note ->
        Repo.delete(trackday_note)

      _ ->
        {:error, %{message: "Trackday note not found"}}
    end
  end

  def get_trackdays_by_month(%{year: year, month: month}) do
    start = Timex.beginning_of_month(year, month) |> Timex.to_naive_datetime()
    last = Timex.end_of_month(year, month) |> Timex.to_naive_datetime()

    Repo.all(from t in Trackday, where: t.end_datetime <= ^last and t.start_datetime >= ^start)
  end

  def get_trackday_by_id(id) when is_binary(id) do
    Repo.one(from t in Trackday, where: t.id == ^id)
  end

  def save_user_trackday_calendar(attrs) do
    %UserTrackdayCalendar{}
    |> UserTrackdayCalendar.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_trackday_calendar(user_id, trackday_id)
      when is_binary(user_id) and is_binary(trackday_id) do
    Repo.one(
      from u in UserTrackdayCalendar,
        where: u.user_id == ^user_id and u.trackday_id == ^trackday_id
    )
  end

  def delete_user_trackday_calendar(user_id, trackday_id)
      when is_binary(user_id) and is_binary(trackday_id) do
    with %UserTrackdayCalendar{} = user_trackday_calendar <-
           get_user_trackday_calendar(user_id, trackday_id),
         res <- Repo.delete(user_trackday_calendar) do
      res
    else
      nil -> {:error, error: true, message: "User trackday calendar not found"}
      error -> error
    end
  end

  def get_upcoming_trackdays(user_id) when is_binary(user_id) do
    trackday_ids =
      from utc in UserTrackdayCalendar,
        where: utc.user_id == ^user_id,
        select: utc.trackday_id

    today = NaiveDateTime.local_now()

    query =
      from t in Trackday,
        where: t.id in subquery(trackday_ids) and t.end_datetime >= ^today,
        order_by: [:start_datetime],
        limit: 1

    Repo.all(query)
  end

  # def get_it do
  #   trackdays = from t in TrackdayNote, distinct: t.user_id,order_by: [:lap_time], limit: 1

  #   query =
  #     from f in Facility,
  #       join: t in Track,
  #       on: t.facility_id == f.id,
  #       join: r in subquery(trackdays),
  #       on: r.track_id == t.id

  #   Repo.all(query)
  # end
  def get_it do
    trackday_note_query =
      from tn in TrackdayNote,
        select: %{id: tn.id, row_number: over(row_number(), :track_partition)},
        windows: [track_partition: [partition_by: [:track_id, :user_id], order_by: :lap_time]]

    track_query =
      from tn in TrackdayNote,
        join: b in subquery(trackday_note_query),
        on: tn.id == b.id and b.row_number <= 2

    Repo.all(from t in Track, preload: [trackday_notes: ^track_query])
  end

  def do_it do
    track_id = "158ff4ee-febd-4430-9863-6f92b9724766"

    query =
      from t in TrackdayNote,
        where: t.track_id == ^track_id and t.lap_time > 0,
        order_by: t.lap_time,
        distinct: t.user_id,
        preload: [:track],
        limit: 3

    Repo.all(query)
  end

  def get_facility_leaderboard(facility_id) do
    query =
      from tn in TrackdayNote,
        join: u in User,
        on: tn.user_id == u.id,
        join: m in Motorcycle,
        on: m.id == tn.motorcycle_id,
        group_by: [u.id, tn.lap_time, m.id, tn.track_id],
        order_by: tn.lap_time,
        select: %{user: u, time: min(tn.lap_time), motorcycle: m},
        limit: 3

    Repo.one(
      from f in Facility, where: f.id == ^facility_id, preload: [tracks: [trackday_notes: ^query]]
    )
  end
  # This doesn't depend on dataloader so less query but more complex and types are not consistant
  # def get_facility_leaderboard(facility_id) do
  #   query =
  #     from tn in TrackdayNote,
  #       join: u in User,
  #       on: tn.user_id == u.id,
  #       join: m in Motorcycle,
  #       on: m.id == tn.motorcycle_id,
  #       join: model in Model,
  #       on: model.id == m.model_id,
  #       join: make in Make,
  #       on: make.id == model.make_id,
  #       group_by: [u.id, tn.lap_time, m.id, model.id, make.id, tn.track_id],
  #       order_by: tn.lap_time,
  #       select: %{user: u, time: min(tn.lap_time), year: m.year, model: model.name, make: make.name},
  #       limit: 3

  #   Repo.one(
  #     from f in Facility, where: f.id == ^facility_id, preload: [tracks: [trackday_notes: ^query]]
  #   )
  # end
end
