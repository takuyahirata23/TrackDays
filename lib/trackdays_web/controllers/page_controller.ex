defmodule TrackdaysWeb.PageController do
  use TrackdaysWeb, :controller

  alias Trackdays.Business

  def home(conn, _params) do
    organizations = Business.get_organizations()

    render(conn, :home, organizations: organizations)
  end
end
