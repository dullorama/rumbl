defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Accounts.User
  alias Rumbl.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, :show, user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: ~p"/users/#{user.id}")
      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        render(conn, :new, changeset: changeset)
    end
  end
end
