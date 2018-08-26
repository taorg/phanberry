defmodule Uisrv.Model.Accounts.User do
  use Ecto.Schema
  use GuardianTrackable.Schema
  import Ecto.Changeset
  alias Uisrv.Model.Accounts.User

  schema "users" do
    field(:role, :string, default: "user", null: false)
    field(:email, :string, null: false)
    guardian_trackable()
    timestamps()
  end

  def changeset(%User{} = user, params) do
    user
    |> cast(params, [:role, :email])
    |> validate_required([:role, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
