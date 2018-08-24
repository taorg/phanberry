# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Uisrv.Repo.insert!(%Uisrv.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Uisrv.Repo, only: [delete_all: 1, insert!: 1]
alias Uisrv.Model.Accounts.User

%User{}
|>User.changeset(%{role: "admin", email: "admin@phantaberry.tv"})
|>insert!
