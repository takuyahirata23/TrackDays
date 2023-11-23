defmodule TrackdaysWeb.Admin.OrganizationsLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Business
  alias Trackdays.Business.Organization
  
  def render(assigns) do
    ~H"""
    <div>
      <h1 class="font-bold text-xl mb-8">Organizations</h1>
      <div class="flex flex-col gap-y-8">
        <.card title="Add Organization">
          <.simple_form for={@organization_form} phx-submit="add-organization">
            <div class="flex flex-col gap-y-4 mb-6">
              <.input field={@organization_form[:name]} type="text" label="Name" required />
              <.input field={@organization_form[:trackdays_registration_url]} type="text" label="Trackday registration URL" />
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
            <li :for={organization <- @organizations}>
              <.link navigate={~p"/admin/business/organizations/#{organization.id}"}>
                <%= organization.name %>
              </.link>
            </li>
          </ul>
        </.card>
      </div>
    </div>
    """
  end

  def mount(_, _, socket) do
    organization_form = Organization.changeset(%Organization{}) |> to_form()
    organizations = Business.get_organizations()

    {:ok, assign(socket, organization_form: organization_form, organizations: organizations)}
  end

  def handle_event("add-organization", %{"organization" => attrs}, socket) do
    case Business.register_organization(attrs) do
      {:error, %Ecto.Changeset{} = changeset } ->
        orgnaization_form = to_form(changeset)
        {:noreply, socket |> put_flash(:error, "Promlem registering organization") |> assign(orgnaization_form: orgnaization_form)}

      {:ok, organization} ->
        organization_form = Organization.changeset(%Organization{}) |> to_form()

        organizations =
          List.insert_at(socket.assigns.organizations, length(socket.assigns.organizations), organization)
        {:noreply, socket |> put_flash(:info, "Registered organization") |> assign(organization_form: organization_form, organizations: organizations)} 
    end
  end
end
