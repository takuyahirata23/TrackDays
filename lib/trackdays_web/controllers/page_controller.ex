defmodule TrackdaysWeb.PageController do
  use TrackdaysWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
