defmodule TrackdaysWeb.ImageController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts

  @bucket_name System.get_env("BUCKET")

  def profile(conn, %{"image" => image}) do
    filename = "#{conn.assigns.current_user.id}-profile.jpg"

    image =
      image.path
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload(@bucket_name, filename)
      |> ExAws.request()

    with {:ok, res} <- image,
         {:ok, _user} <-
           Accounts.upsert_profile_image_url(res.body.location, conn.assigns.current_user) do
      conn
      |> put_status(201)
      |> render(:profile_image_uploaded)
    else
      _ ->
        conn
        |> put_status(304)
        |> render(:profile_image_not_uploaded)
    end
  end
end
