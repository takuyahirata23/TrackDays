defmodule TrackdaysWeb.OrganizationsController do
  use TrackdaysWeb, :controller

  alias Trackdays.Business

  def organization(conn, %{"id" => id}) do
    organization = Business.get_organization(id)
    trackdays = Business.get_future_trackdays(id)

    render(conn, :organization, organization: organization, trackdays: trackdays)
  end
end
