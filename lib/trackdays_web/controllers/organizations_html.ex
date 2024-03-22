defmodule TrackdaysWeb.OrganizationsHTML do
  use TrackdaysWeb, :html
  require Integer

  embed_templates "organizations_html/*"

  def pick_trackday_registration_url(specific, default) do
    if specific, do: specific, else: default
  end

  def pick_table_class(index) do
    dark = "bg-card-dark-bg-primary text-card-dark-primary"
    light = "bg-card-dark-bg-secondary text-card-dark-secondary"
    if Integer.is_even(index), do: dark, else: light
  end
end
