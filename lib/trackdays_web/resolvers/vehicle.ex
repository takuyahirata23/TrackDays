defmodule TrackdaysWeb.Resolvers.Vehicle do
  alias Trackdays.Vehicle

  def get_makes(_, _, _) do
    {:ok, Vehicle.get_all_makes()}
  end
end
