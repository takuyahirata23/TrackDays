defmodule TrackdaysWeb.Plugs.SetUser do
  import Plug.Conn

  alias Trackdays.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Accounts.get_user_by_token(token) do
      %{current_user: user}
    else
      _ ->
        %{current_user: nil}
    end
  end
end
