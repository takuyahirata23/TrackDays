defmodule TrackdaysWeb.Admin.OrganizationDetailLive do
  import Number
  use TrackdaysWeb, :live_view

  alias Trackdays.Business
  alias TrackdaysWeb.Helpers.Datetime

  def render(assigns) do
    ~H"""
    <div>
      <a href={@organization.homepage_url} target="_blank">
        <h1 class="font-bold text-xl mb-6"><%= @organization.name %></h1>
      </a>
    </div>
    <div :if={@organization.default_note} class="mt-6 max-w-prose mb-6">
      <p class="whitespace-pre-line"><%= @organization.default_note %></p>
    </div>
    <ul class="flex flex-col gap-y-4">
      <li :for={trackday <- @organization.trackdays}>
        <.card class="md:space-y-2">
          <div>Facility: <%= trackday.track.facility.name %></div>
          <div>Track: <%= trackday.track.name %></div>
          <div>
            Date: <%= Datetime.format_datetime(trackday.start_datetime) %> - <%= Datetime.format_date(
              trackday.end_datetime
            ) %>
          </div>
          <div>Price: <%= Number.Currency.number_to_currency(trackday.price) %></div>
          <div :if={trackday.description}>Description: <%= trackday.description %></div>
          <.link
            navigate={
              ~p"/admin/business/organizations/#{@organization.id}/trackdays/#{trackday.id}/edit"
            }
            class="px-4 py-1 mt-6 bg-btn-bg-primary text-btn-primary rounded inline-block"
          >
            Edit
          </.link>
        </.card>
      </li>
    </ul>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    organization = Business.get_organization_with_trackdays(id)

    {:ok, assign(socket, organization: organization)}
  end
end
