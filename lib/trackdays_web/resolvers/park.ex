defmodule TrackdaysWeb.Resolvers.Park do
  alias Trackdays.Park

  def get_facilities(_, _, _) do
    {:ok, Park.get_facilities()}
  end

  def get_facility(_, %{id: id}, _) do
    {:ok, Park.get_facility(id)}
  end

  def get_tracks(_, %{facility_id: id}, _) do
    {:ok, Park.get_tracks_by_facility_id(id)}
  end
end
