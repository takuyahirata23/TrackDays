defmodule TrackdaysWeb.AssetStore do
  def upload_image(file) do
    IO.inspect(File.cp(file.path, "./test1.jpg"))
  end
end
