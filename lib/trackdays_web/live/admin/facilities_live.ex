defmodule TrackdaysWeb.Admin.FacilitiesLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Park
  alias Trackdays.Park.Facility

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="font-bold text-xl mb-8">Facilities</h1>
      <div class="flex flex-col gap-y-8">
        <.card title="Add Facility">
          <.simple_form for={@facility_form} phx-submit="add-facility">
            <div class="flex flex-col gap-y-4 mb-6">
              <.input field={@facility_form[:name]} type="text" label="Name" required />
              <.input field={@facility_form[:description]} type="textarea" label="Description" />
            </div>
            <:actions>
              <.button phx-disable-with="Registering..." class="w-full">
                Register facility <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
        </.card>

        <.card margin_bottom={false}>
          <ul class="flex flex-col gap-y-4">
            <li :for={facility <- @facilities}>
              <.link navigate={~p"/admin/park/facilities/#{facility.id}"}>
                <%= facility.name %>
              </.link>
            </li>
          </ul>
        </.card>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    facility_form = Facility.changeset(%Facility{}) |> to_form()
    facilities = Park.get_facilities()
    {:ok, assign(socket, facility_form: facility_form, facilities: facilities)}
  end

  def handle_event("add-facility", %{"facility" => attrs}, socket) do
    case Park.save_facility(attrs) do
      {:error, %Ecto.Changeset{} = changeset} ->
        facility_form = to_form(changeset)

        {:noreply,
         socket
         |> put_flash(:error, "Problem saving facility")
         |> assign(facility_form: facility_form)}

      {:ok, facility} ->
        facility_form = Facility.changeset(%Facility{}) |> to_form()

        # TODO: use append to show new facilitys
        facilities =
          List.insert_at(socket.assigns.facilities, length(socket.assigns.facilities), facility)

        {:noreply,
         socket
         |> put_flash(:info, "Saved facility")
         |> assign(facility_form: facility_form, facilities: facilities)}
    end
  end
end
