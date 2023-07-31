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
end
