defmodule Trackdays.Park do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Park.{Facility, Track}

  def save_facility(attrs) do
    %Facility{}
    |> Facility.changeset(attrs)
    |> Repo.insert()
  end

  def get_facilities do
    Repo.all(from f in Facility, order_by: f.name)
  end

  def get_facility_and_tracks(id) when is_binary(id) do
    Repo.one(
      from t in Facility,
        where: t.id == ^id,
        preload: [:tracks]
    )
  end

  def get_facility(id) when is_binary(id) do
    Repo.one(
      from t in Facility,
        where: t.id == ^id
    )
  end

  def save_track(attrs, facility) do
    %Track{}
    |> Track.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:facility, facility)
    |> Repo.insert()
  end

  def get_tracks_by_facility_id(id) when is_binary(id) do
    Repo.all(
      from t in Track,
        where: t.facility_id == ^id
    )
  end
end
