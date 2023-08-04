defmodule Trackdays.Event do
  import Ecto.Query, warn: false

  alias Trackdays.Repo
  alias Trackdays.Event.Trackday

  def save_trackday(attrs, user) do
    %Trackday{}
    |> Trackday.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def get_trackdays_by_user_id(id) when is_binary(id) do
    Repo.all(from t in Trackday, where: t.user_id == ^id)
  end

  def get_trackday_by_trackday_id(id) when is_binary(id) do
    Repo.one(from t in Trackday, where: t.id == ^id)
  end
end
