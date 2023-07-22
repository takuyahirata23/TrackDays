defmodule Trackdays.Vehicle do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Vehicle.{Make, Model, Motorcycle}

  def save_make(attrs) do
    %Make{}
    |> Make.changeset(attrs)
    |> Repo.insert()
  end

  def get_all_makes do
    Repo.all(Make)
  end

  def get_make_detail(id) when is_binary(id) do
    Repo.one(
      from ma in Make,
        where: ma.id == ^id,
        preload: [:models]
    )
  end

  def save_model(attrs, make) do
    %Model{}
    |> Model.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:make, make)
    |> Repo.insert()
  end

  def get_models_by_make_id(make_id) when is_binary(make_id) do
    Repo.all(from m in Model, where: m.make_id == ^make_id)
  end

  def register_motorcycle(attrs) do
    %Motorcycle{}
    |> Motorcycle.chagneset(attrs)
    |> Repo.insert()
  end
end
