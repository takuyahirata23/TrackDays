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
    Repo.all(Facility)
  end

  def get_facility(id) when is_binary(id) do
    Repo.one(
      from t in Facility,
        where: t.id == ^id,
        preload: [:tracks]
    )
  end

  def save_track(attrs, facility) do
    %Track{}
    |> Track.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:facility, facility)
    |> Repo.insert()
  end
end
