defmodule TrackdaysWeb.OrganizationsHTML do
  use TrackdaysWeb, :html
  import Integer

  embed_templates "organizations_html/*"

  def pick_trackday_registration_url(specific, default) do
    if specific, do: specific, else: default
  end
end
