defmodule Uisrv.Auth.Guardian do
  use Guardian, otp_app: :uisrv
  use SansPassword

  alias Uisrv.Model.Accounts

  @impl true
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  @impl true
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user(id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @impl true
  def deliver_magic_link(_usr, magic_token, _opts) do
    require Logger
    alias UisrvWeb.Endpoint
    import UisrvWeb.Router.Helpers
    Logger.debug("Endpoint : #{inspect(Endpoint.static_url)}")
    Logger.debug("Endpoint : #{inspect(Endpoint.host)}")
    Logger.info("""

    Typically, we'd send an email here, but for the purposes of this
    demo, you can just click this link in your console:

        #{auth_url(Endpoint, :callback, magic_token)}

    """)
  end

  @impl true
  def after_sign_in(conn, resource, _token, _claims, _opts) do
    GuardianTrackable.track!(Uisrv.Repo, resource, conn.remote_ip)
    {:ok, conn}
  end
end
