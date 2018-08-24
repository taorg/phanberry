defmodule Uisrv.Repo do
  use Ecto.Repo, otp_app: :uisrv, adapter: Sqlite.Ecto2
end
