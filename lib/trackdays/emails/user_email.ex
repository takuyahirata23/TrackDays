defmodule Trackdays.Emails.UserEmail do
  use Phoenix.Swoosh,
    template_root: "lib/trackdays_web/emails",
    template_path: "users"

  def welcome(user, verify_link) do
    new()
    |> to({user.name, user.email})
    |> from({"Trackdays", "hello@cookies.com"})
    |> subject("Welcome to Trackdays!")
    |> render_body("welcome.html", %{name: user.name, verify_link: verify_link})
  end

  def new_email_verification(name, new_email, verify_link) do
    new()
    |> to({ name, new_email})
    |> from({"Trackdays", "hello@cookies.com"})
    |> subject("Please verify your new email address")
    |> render_body("new_email_verification.html", %{name: name, verify_link: verify_link})
  end
end
