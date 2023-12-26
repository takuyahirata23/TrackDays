defmodule Trackdays.Emails.UserEmail do
  import Swoosh.Email

  @url System.get_env("BASE_URL")

  # Signup Email Verification
  def welcome(user, verify_link) do
    IO.inspect("#{@url}#{verify_link}", label: "URL")

    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(user.email)
    |> put_provider_option(:template_id, 4)
    |> put_provider_option(:params, %{link: "#{@url}#{verify_link}", name: user.name})
  end

  # Email Verification 
  def new_email_verification(name, new_email, verify_link) do
    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(new_email)
    |> put_provider_option(:template_id, 2)
    |> put_provider_option(:params, %{link: "#{@url}#{verify_link}", name: name})
  end

  # Password Update Request
  def password_update_request(user, link) do
    new()
    |> from("support@motorcycle-trackdays.com")
    |> to(user.email)
    |> put_provider_option(:template_id, 5)
    |> put_provider_option(:params, %{link: "#{@url}#{link}", name: user.name})
  end
end
