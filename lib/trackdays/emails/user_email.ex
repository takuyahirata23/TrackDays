defmodule Trackdays.Emails.UserEmail do
  import Swoosh.Email

  use Phoenix.Swoosh,
    template_root: "lib/trackdays_web/emails",
    template_path: "users"

  def welcome(user, verify_link) do
    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(user.email)
    |> put_provider_option(:template_id, 2)
    |> put_provider_option(:params, %{link: verify_link})
  end

  def new_email_verification(_name, new_email, verify_link) do
    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(new_email)
    |> put_provider_option(:template_id, 2)
    |> put_provider_option(:params, %{link: verify_link})
  end
end
