defmodule Trackdays.Vehicle do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Vehicle.{Make}

  def save_make(attrs) do
    %Make{}
    |> Make.changeset(attrs)
    |> Repo.insert()
  end

  def get_all_makes do
    Repo.all(Make)
  end
end
