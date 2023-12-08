defmodule TrackdaysWeb.AuthController do
  use TrackdaysWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    IO.inspect(conn, label: "conn")
    IO.inspect(params, label: "params")
  end
end
