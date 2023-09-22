defmodule Trackdays.Emails.UserEmail do
  use Phoenix.Swoosh,
    template_root: "lib/trackdays_web/emails",
    template_path: "welcome"

  def welcome(user) do
    new()
    |> to({user.name, user.email})
    |> from({"Trackdays", "hello@cookies.com"})
    |> subject("Welcome to Trackdays!")
    |> render_body("welcome.html", %{name: user.name})
  end
end
