defmodule TrackdaysWeb.Admin.OrganizationDetailLive do
  use TrackdaysWeb, :live_view

  alias Trackdays.Business

  def render(assigns) do
    ~H"""
    <div>
    <a href={@organization.homepage_url} target="_blank">
      <h1 class="font-bold text-xl mb-6"><%= @organization.name %></h1>
    </a>
    </div>
    <ul class="flex flex-col gap-y-4">
      <li :for={trackday <- @organization.trackdays}>
        <div class="p-4 rounded bg-bg-secondary">
          <div>Facility: <%= trackday.track.facility.name %></div>
          <div>Track: <%= trackday.track.name %></div>
          <div>Date: <%= trackday.date %></div>
          <div>Price: $<%= trackday.price %></div>
        </div>
      </li>
    </ul>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    organization = Business.get_organization_with_trackdays(id)

    {:ok, assign(socket, organization: organization)}
  end
end
