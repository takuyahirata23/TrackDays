defmodule TrackdaysWeb.Resolvers.Park do
  alias Trackdays.Park

  def get_facilities(_, _, _) do
    {:ok, Park.get_facilities()}
  end
end
