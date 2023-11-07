defmodule TrackdaysWeb.Resolvers.Accounts do
  def get_user(_, _, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def save_profile_image(_, %{image_url: _image_url}, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end
end
