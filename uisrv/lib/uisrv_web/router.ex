defmodule UisrvWeb.Router do
  use UisrvWeb, :router

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug(Uisrv.Auth.UserManager.Pipeline)
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", UisrvWeb do
    # Use the default browser stack
    pipe_through([:browser, :auth])

    get("/", PageController, :index)

    get("/login", AuthController, :new)
    get("/logout", AuthController, :destroy)
    post("/login", AuthController, :create)
    get("/login/:magic_token", AuthController, :callback)
  end

  # Definitely logged in scope
  scope "/", UisrvWeb do
    pipe_through([:browser, :auth, :ensure_auth])

    get("/secret", PageController, :secret)
  end

  # Other scopes may use custom stacks.
  # scope "/api", UisrvWeb do
  #   pipe_through :api
  # end
end
