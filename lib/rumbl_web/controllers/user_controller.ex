defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Accounts.User
  alias Rumbl.Accounts

  plug :authorize when action in [:index, :show]

  def index(conn, _params) do
      users = Accounts.list_users()
      render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, :show, user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: ~p"/users/#{user.id}")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  defp authorize(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must login to access that page!")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
