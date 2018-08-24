defmodule Uisrv.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :role, :string, [default: "user", null: false]
      add :email, :string, [null: false]
      #:guardian_trackable fields
      add :sign_in_count, :integer, default: 0
      add :last_sign_in_ip, :string
      add :last_sign_in_at, :utc_datetime
      add :current_sign_in_ip, :string
      add :current_sign_in_at, :utc_datetime
      timestamps()
    end
  end
end
