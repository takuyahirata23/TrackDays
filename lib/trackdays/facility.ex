defmodule Trackdays.Facility do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Facility.Track

  def save_track(attrs) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  def get_tracks do
    Repo.all(Track)
  end

  def get_track(id) when is_binary(id) do
    Repo.one(
      from t in Track,
        where: t.id == ^id,
        preload: [:layouts]
    )
  end
end
