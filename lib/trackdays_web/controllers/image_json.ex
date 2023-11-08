defmodule TrackdaysWeb.ImageJSON do
  def profile_image_uploaded(_) do 
    %{error: false, message: "Profile image uploaded"}
  end

  def profile_image_not_uploaded(_) do 
    %{error: true, message: "Profile image not uploaded"}
  end
end
