defmodule UisrvWeb.Router do
  use UisrvWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)

    plug(Guardian.Plug.Pipeline,
      module: UisrvWeb.Guardian,
      error_handler: UisrvWeb.AuthController
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", UisrvWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/login", AuthController, :new)
    get("/logout", AuthController, :destroy)
    post("/login", AuthController, :create)
    get("/login/:magic_token", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", UisrvWeb do
  #   pipe_through :api
  # end
end
