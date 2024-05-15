defmodule Rumbl.Accounts.Session do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
    field :password, :string
  end

  def changeset(session, params) do
    session
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
  end

end
