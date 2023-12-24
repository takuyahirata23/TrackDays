defmodule TrackdaysWeb.Resolvers.Event do
  alias Trackdays.Event

  def save_trackday_note(_, %{save_trackday_note_input: attrs}, %{context: %{current_user: user}}) do
    case Event.save_trackday_note(attrs, user) do
      {:error, changeset} ->
        {:error,
         message: "Saving trackday failed",
         errors:
           Ecto.Changeset.traverse_errors(
             changeset,
             &TrackdaysWeb.CoreComponents.translate_error/1
           )}

      {:ok, trackday} ->
        {:ok, Event.get_trackday_note_by_id(trackday.id)}
    end
  end

  def get_trackday_notes(_, _, %{context: %{current_user: user}}) do
    {:ok, Event.get_trackday_notes_by_user_id(user.id)}
  end

  def get_trackday_notes_by_month(_, %{get_events_by_month_input: arg}, %{
        context: %{current_user: user}
      }) do
    {:ok, Event.get_trackday_notes_by_month(user.id, arg)}
  end

  def get_trackday_note_by_id(_, %{id: id}, _) do
    {:ok, Event.get_trackday_note_by_id(id)}
  end

  def get_best_lap_for_each_track(_, _, %{context: %{current_user: user}}) do
    {:ok, Event.get_best_lap_for_each_track(user.id)}
  end

  def update_trackday_note(_, %{update_trackday_note_input: attrs}, _) do
    case Event.update_trackday_note(attrs) do
      {:ok, trackday} ->
        {:ok, trackday}

      {_, %Ecto.Changeset{} = changeset} ->
        {:error,
         message: "Updating trackday note failed",
         errors:
           Ecto.Changeset.traverse_errors(
             changeset,
             &TrackdaysWeb.CoreComponents.translate_error/1
           )}

      _ ->
        {:error, message: "Trackday note not found"}
    end
  end

  def delete_trackday_note(_, %{id: id}, %{context: %{current_user: user}}) do
    Event.delete_trackday_note(id, user.id)
  end

  def get_trackdays_by_month(_, %{get_events_by_month_input: arg}, _) do
    {:ok, Event.get_trackdays_by_month(arg)}
  end

  def get_trackday(_, %{id: id}, _) do
    {:ok, Event.get_trackday_by_id(id)}
  end

  def save_user_trackday_calendar(_, %{save_user_trackday_calendar_input: args}, %{
        context: %{current_user: user}
      }) do
    attrs = Map.put(args, :user_id, user.id)

    case Event.save_user_trackday_calendar(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        {:error,
         message: "Saving user trackday calendar failed",
         errors:
           Ecto.Changeset.traverse_errors(
             changeset,
             &TrackdaysWeb.CoreComponents.translate_error/1
           )}

      {:ok, user_trackday_calendar} ->
        {:ok, user_trackday_calendar}
    end
  end

  def get_user_trackday_calendar(_, %{trackday_id: trackday_id}, %{context: %{current_user: user}}) do
    {:ok, Event.get_user_trackday_calendar(user.id, trackday_id)}
  end

  def delete_user_trackday_calendar(_, %{trackday_id: trackday_id}, %{
        context: %{current_user: user}
      }) do
    Event.delete_user_trackday_calendar(user.id, trackday_id)
  end
end
