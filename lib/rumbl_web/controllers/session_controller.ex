defmodule RumblWeb.SessionController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias Rumbl.Accounts.Session

  def new(conn, _params) do
    changeset = Accounts.change_login(%Session{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Accounts.authenticate(username, password) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: ~p"/users")

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid username/password combination")
        |> new(%{})
    end
  end
end
