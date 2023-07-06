defmodule TrackdaysWeb.Admin.MakeLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Vehicle
  alias Trackdays.Vehicle.Make

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="font-bold text-xl mb-8">Makes</h1>
      <div class="flex flex-col gap-y-8">
        <.card title="Add Make">
          <.simple_form for={@make_form} phx-submit="add-make">
            <.input field={@make_form[:name]} type="text" label="Name" required />
            <:actions>
              <.button phx-disable-with="Registering..." class="w-full">
                Register make <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </.card>
        <.card margin_bottom={false}>
          <ul class="flex flex-col gap-y-4">
            <li :for={make <- @makes}>
              <span>
                <%= make.name %>
              </span>
            </li>
          </ul>
        </.card>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    make_form = Make.changeset(%Make{}) |> to_form()
    makes = Vehicle.get_all_makes()
    {:ok, assign(socket, make_form: make_form, makes: makes)}
  end

  def handle_event("add-make", %{"make" => attrs}, socket) do
    case Vehicle.save_make(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        make_form = to_form(changeset)

        {:noreply,
         socket |> put_flash(:error, "Problem saving make") |> assign(make_form: make_form)}

      {:ok, make} ->
        make_form = Make.changeset(%Make{}) |> to_form()
        makes = List.insert_at(socket.assigns.makes, length(socket.assigns.makes), make)

        {:noreply,
         socket |> put_flash(:info, "Saved make") |> assign(make_form: make_form, makes: makes)}
    end
  end
end
