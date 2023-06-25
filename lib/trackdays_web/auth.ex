defmodule TrackdaysWeb.Auth do
  alias Trackdays.Accounts
  use TrackdaysWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  def log_in_to_admin(conn, user) do
    if user.is_admin do
      key = Application.fetch_env!(:trackdays, :token_secret_key)
      token = Phoenix.Token.sign(TrackdaysWeb.Endpoint, key, user.id)

      conn
      |> put_token_in_session(token)
      |> redirect(to: ~p"/admin/dashboard")
    else
      redirect(conn, to: ~p"/")
    end
  end

  def require_admin_user(conn, _opts) do
    if conn.assigns[:current_user] && conn.assigns[:current_user].is_admin do
      conn
    else
      conn
      |> put_flash(:error, "Admin only contents")
      |> redirect(to: ~p"/admin/log_in")
      |> halt()
    end
  end

  def on_mount(:ensure_admin, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user && socket.assigns.current_user.is_admin do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "Admin only contents!")
        |> Phoenix.LiveView.redirect(to: ~p"/")

      {:halt, socket}
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    key = Application.fetch_env!(:trackdays, :token_secret_key)

    case Phoenix.Token.verify(TrackdaysWeb.Endpoint, key, user_token) do
      {:ok, id} ->
        assign(conn, :current_user, Accounts.get_user_by_id(id))

      _ ->
        assign(conn, :current_user, nil)
    end
  end

  defp ensure_user_token(conn) do
    if token = get_session(conn, :user_token) do
      {token, conn}
    else
      {nil, conn}
    end
  end

  defp mount_current_user(session, socket) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      key = Application.fetch_env!(:trackdays, :token_secret_key)

      case Phoenix.Token.verify(TrackdaysWeb.Endpoint, key, session["user_token"]) do
        {:ok, id} ->
          Accounts.get_user_by_id(id)

        _ ->
          IO.puts("run")
          nil
      end
    end)
  end
end
