defmodule Trackdays.Business do
  import Ecto.Query, warn: false

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

  def get_future_trackdays(organization_id) when is_binary(organization_id) do
    today = NaiveDateTime.local_now()

    query =
      from td in Trackday,
        where: td.organization_id == ^organization_id and td.end_datetime >= ^today,
        preload: [track: :facility]

    Repo.all(query)
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
