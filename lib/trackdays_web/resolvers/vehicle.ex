defmodule TrackdaysWeb.Resolvers.Vehicle do
  alias Trackdays.Vehicle

  def get_makes(_, _, _) do
    {:ok, Vehicle.get_all_makes()}
  end

  def get_models(_, %{make_id: make_id}, _) do
    {:ok, Vehicle.get_models_by_make_id(make_id)}
  end

  def register_motorcycle(_, %{register_motorcycle_input: attrs}, %{
        context: %{current_user: current_user}
      }) do
    attrs = Map.put(attrs, :user_id, current_user.id)

    case Vehicle.register_motorcycle(attrs) do
      {:ok, motorcycle} ->
        {:ok, Vehicle.get_motorcycle(motorcycle.id, current_user.id)}

      {:error, changeset} ->
        {:error,
         message: "Motorcycle registration failed",
         errors:
           Ecto.Changeset.traverse_errors(
             changeset,
             &TrackdaysWeb.CoreComponents.translate_error/1
           )}
    end
  end

  def get_motorcycles(_, _, %{context: %{current_user: current_user}}) do
    {:ok, Vehicle.get_motorcycles(current_user.id)}
  end
end
