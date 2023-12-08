defmodule TrackdaysWeb.PasswordUpdateLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Accounts
  alias Trackdays.Accounts.{PasswordUpdateRequest}

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="password_update_form"
        action={~p"/admin/log_in"}
        phx-submit="submit"
      >
        <div class="flex flex-col gap-y-6">
          <.input field={@form[:password]} type="password" label="Password" required />
        </div>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Update <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(%{"id" => id}, _, socket) do
    request = Accounts.get_password_update_request_by_id(id)
    form = to_form(%{"password" => "", "id" => request.user_id}, as: "user")

    {:ok, assign(socket, form: form, request: request)}
  end

  def handle_event("submit", %{"user" => attrs}, socket) do
    password_update_request = socket.assigns.request
    user = Accounts.get_user_by_id(password_update_request.user_id)

    case Accounts.update_password(user, attrs["password"], password_update_request) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password updated")
         |> redirect(to: ~p"/accounts/verification_success")}

      {:error, %Ecto.Changeset{} = changeset} ->
        form = to_form(changeset)

        {:noreply, socket |> put_flash(:error, "Password is not valid") |> assign(form: form)}
    end
  end
end
