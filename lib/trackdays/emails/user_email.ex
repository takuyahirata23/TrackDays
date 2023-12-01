defmodule Trackdays.Emails.UserEmail do
  import Swoosh.Email

  # use Phoenix.Swoosh,
  #   template_root: "lib/trackdays_web/emails",
  #   template_path: "users"

  # Signup Email Verification
  def welcome(user, verify_link) do
    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(user.email)
    |> put_provider_option(:template_id, 4)
    |> put_provider_option(:params, %{link: verify_link, name: user.name})
  end

  # Email Verification 
  def new_email_verification(name, new_email, verify_link) do
    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(new_email)
    |> put_provider_option(:template_id, 2)
    |> put_provider_option(:params, %{link: verify_link, name: name})
  end
end
