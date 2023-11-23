defmodule Trackdays.Business do
  import Ecto.Query, warn: false

  alias Hex.API.Key.Organization
  alias Hex.API.Key.Organization
  alias Hex.API.Key.Organization
  alias Trackdays.Repo
  alias Trackdays.Business.Organization
  alias Trackdays.Event.Trackday
  alias Trackdays.Park.{Track, Facility}

  def register_organization(attrs) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  def get_organizations do
    Repo.all(Organization)
  end

  def get_organization(id) when is_binary(id) do
    Repo.one(from o in Organization, where: o.id == ^id)
  end

  def get_organization_options_for_select do
    Organization
    |> select([o], {o.name, o.id})
    |> order_by([o], asc: o.name)
    |> Repo.all()
  end

  def get_track_options_for_select do
    query =
      from t in Track,
        join: f in Facility,
        on: t.facility_id == f.id,
        select: %{track: t.name, id: t.id, facility: f.name},
        order_by: [asc: f.name, asc: t.name]

    Repo.all(query)
  end

  def register_trackday(attrs) do
    %Trackday{}
    |> Trackday.changeset(attrs)
    |> Repo.insert()
  end

  def get_organization_with_trackdays(id) when is_binary(id) do
    query =
      from o in Organization,
      where: o.id == ^id,
      preload: [:trackdays, trackdays: :track, trackdays: [track: :facility]]

    Repo.one(query)
  end
end
