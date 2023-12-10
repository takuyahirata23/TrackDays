defmodule TrackdaysWeb.Plugs.RequireUserActions do
  import Plug.Conn

  alias Trackdays.Accounts

  def init(opts), do: opts

  def call(conn, _default) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Accounts.get_user_by_token(token) do
      authorized(conn, user)
    else
      _ ->
        reject(conn)
    end
  end

  defp reject(conn) do
    conn |> send_resp(401, "Unauthorized") |> halt()
  end

  defp authorized(conn, user) do
    conn |> assign(:current_user, user)
  end
end
