defmodule TrackdaysWeb.Plugs.RequireUser do
  import Plug.Conn
  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.private[:absinthe].context.current_user do
      nil ->
        body = Jason.encode!(%{error: "Not authorized"})
        send_resp(conn, 401, body) |> halt()

      %{} ->
        conn
    end
  end
end
