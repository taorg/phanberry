defmodule Uisrv.Model.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string, null: false)
    field(:email, :string, null: false)
    field(:password, :string, null: false)
    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
