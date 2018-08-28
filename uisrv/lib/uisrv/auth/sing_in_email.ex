defmodule Uisrv.Auth.SingInEmail do
  import Swoosh.Email

  def welcome(user,magic_url) do
    new()
    |> to({user.role, user.email})
    |> from({"Phantaberry", "manumig@gmail.com"})
    |> subject("Phantaberry says hello to you!")
    |> html_body("<h1>Hello #{user.role}</h1> this is your magit url to sing in : <li>#{magic_url}</li>")
    |> text_body("Hello #{user.email}\n ")
  end
end

