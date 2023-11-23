defmodule TrackdaysWeb.Resolvers.Business do
  alias Trackdays.Business
  
  def get_organization(_, %{id: id}, _) do
    {:ok, Business.get_organization(id)}
  end
end
