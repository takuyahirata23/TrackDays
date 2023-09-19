defmodule TrackdaysWeb.Resolvers.Event do
  alias Trackdays.Event

  def save_trackday(_, %{save_trackday_input: attrs}, %{context: %{current_user: user}}) do
    case Event.save_trackday(attrs, user) do
      {:error, changeset} ->
        {:error,
         message: "Saving trackday failed",
         errors:
           Ecto.Changeset.traverse_errors(
             changeset,
             &TrackdaysWeb.CoreComponents.translate_error/1
           )}

      {:ok, trackday} ->
        {:ok, Event.get_trackday_by_trackday_id(trackday.id)}
    end
  end

  def get_trackdays(_, _, %{context: %{current_user: user}}) do
    {:ok, Event.get_trackdays_by_user_id(user.id)}
  end

  def get_trackday_by_month(_, %{get_trackdays_by_month_input: arg}, %{
        context: %{current_user: user}
      }) do
    IO.inspect(user)
    {:ok, Event.get_trackday_by_month(user.id, arg)}
  end

  def get_trackday_by_trackday_id(_, %{id: id}, _) do
    {:ok, Event.get_trackday_by_trackday_id(id)}
  end
end
