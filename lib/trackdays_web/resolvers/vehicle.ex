defmodule TrackdaysWeb.Resolvers.Vehicle do
  alias Trackdays.Vehicle

  def get_makes(_, _, _) do
    {:ok, Vehicle.get_all_makes()}
  end

  def get_models(_, %{make_id: make_id}, _) do
    {:ok, Vehicle.get_models_by_make_id(make_id)}
  end
end
