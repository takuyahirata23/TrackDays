defmodule TrackdaysWeb.ImageController do
  use TrackdaysWeb, :controller

  alias Trackdays.Accounts

  def profile(conn, %{"image" => image}) do
  IO.inspect(System.get_env("AWS_ACCESS_KEY_ID"))
  IO.inspect(System.get_env("AWS_SECRET_ACCESS_KEY"))

    bucket_name = "trackdays-proto"
    filename = "#{conn.assigns.current_user.id}-profile.jpg"

    IO.inspect("Start AWS functions")
    image = 
      image.path
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload(bucket_name, filename)
      |> ExAws.request()
    IO.inspect("End AWS functions")

    IO.inspect(image, label: "Response from AWS")

    with  {:ok, res} <- image,
         {:ok, _user} <- Accounts.upsert_profile_image_url(res.body.location, conn.assigns.current_user) do
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
