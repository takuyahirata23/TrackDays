defmodule TrackdaysWeb.OrganizationController do
  use TrackdaysWeb, :controller

  alias Trackdays.Business

  def organization(conn, _params) do
    render(conn, :organization)
  end
end
