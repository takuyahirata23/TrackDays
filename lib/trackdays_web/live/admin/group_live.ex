defmodule TrackdaysWeb.Admin.GroupLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Accounts
  alias Trackdays.Accounts.Group

  def render(assigns) do
    ~H"""
    <div>
      <h1>Groups</h1>
      <.simple_form for={@form} phx-submit="create-group">
        <.input field={@form[:name]} type="text" label="Name" required />
        <:actions>
          <.button phx-disable-with="Registering..." class="w-full">
            Save Group <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
      <ul>
        <li :for={group <- @groups}>
          <div><%= group.name %></div>
        </li>
      </ul>
    </div>
    """
  end

  def mount(_, _, socket) do
    form = Group.changeset(%Group{}) |> to_form()
    groups = Accounts.get_groups()

    {:ok, assign(socket, form: form, groups: groups)}
  end

  def handle_event("create-group", %{"group" => attrs}, socket) do
    case Accounts.create_group(attrs) do
      {:ok, _group} ->
        form = Group.changeset(%Group{}) |> to_form()
        {:noreply, socket |> put_flash(:info, "Created new group") |> assign(form: form)}

      {:error, %Ecto.Changeset{} = chnageset} ->
        {:noreply, socket |> put_flash(:error, "Error") |> assign(form: to_form(chnageset))}
    end
  end
end
