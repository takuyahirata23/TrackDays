defmodule TrackdaysWeb.Plugs.SetUserId do
  import Plug.Conn

  alias TrackdaysWeb.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, id} <- Auth.verify_token(token) do
      %{user_id: id}
    else
      _ ->
        conn |> send_resp(401, "Please sign in") |> halt
    end
  end
end
