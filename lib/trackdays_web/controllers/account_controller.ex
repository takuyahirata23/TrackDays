defmodule TrackdaysWeb.AccountController do
  use TrackdaysWeb, :controller

  def verification_success(conn, _attrs) do
    render(conn, :verification_success, layout: false)
  end

  def verification_fail(conn, _attrs) do
    render(conn, :verification_fail, layout: false)
  end
end
