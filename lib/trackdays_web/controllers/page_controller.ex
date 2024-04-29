defmodule TrackdaysWeb.PageController do
  use TrackdaysWeb, :controller

  alias Trackdays.Business
  alias Trackdays.Event

  def home(conn, _params) do
    organizations = Business.get_organizations()
    total_trackdays_this_year = Event.count_trackdays_this_year()

    render(conn, :home,
      organizations: organizations,
      total_trackdays_this_year: total_trackdays_this_year
    )
  end
end
