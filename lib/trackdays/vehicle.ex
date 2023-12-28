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
    |> Motorcycle.changeset(attrs)
    |> Repo.insert()
  end

  def get_motorcycle(motorcycle_id, user_id) when is_binary(user_id) do
    Repo.one(
      from motorcycle in Motorcycle,
        where: motorcycle.user_id == ^user_id and motorcycle.id == ^motorcycle_id
    )
  end

  def get_motorcycles(user_id) when is_binary(user_id) do
    Repo.all(
      from m in Motorcycle,
        where: m.user_id == ^user_id and is_nil(m.is_archived)
    )
  end

  def archive_motorcycle(motorcycle_id, user_id) do
    case get_motorcycle(motorcycle_id, user_id) do
      %Motorcycle{} = motorcycle ->
        Ecto.Changeset.change(motorcycle, is_archived: true)
        |> Repo.update()

      _ ->
        {:error, message: "Not found"}
    end
  end

  def datasource do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
