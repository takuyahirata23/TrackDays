defmodule Trackdays.Business do
  import Ecto.Query, warn: false

  alias Hex.API.Key.Organization
  alias Trackdays.Repo
  alias Trackdays.Business.Organization

  def register_organization(attrs) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def get_organizations do
    Repo.all(Organization)
  end
end
