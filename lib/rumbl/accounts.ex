defmodule Rumbl.Accounts do
  @moduledoc """
  The Accounts context
  """
  alias Rumbl.Accounts.{User, Session}
  alias Rumbl.Repo

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
  end

  def change_registration(%User{} = user, params \\ %{}) do
    User.registration_changeset(user, params)
  end

  def change_login(%Session{} = session, params \\ %{}) do
    Session.changeset(session, params)
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert
  end

  def authenticate(username, password) do
    user = get_user_by(username: username)

    cond do
      user && Bcrypt.verify_pass(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true ->
        {:error, :not_found}
    end
  end
end
