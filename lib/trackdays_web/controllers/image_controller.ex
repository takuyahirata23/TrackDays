defmodule TrackdaysWeb.ImageController do
  use TrackdaysWeb, :controller
  
  def profile(conn, %{"image" => image_base64 }) do
    TrackdaysWeb.AssetStore.upload_image(image_base64)
    conn
    |> put_status(201)
    |> render(:profile_image_uploaded)
  end
end
