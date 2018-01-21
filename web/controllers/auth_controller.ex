defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  alias Discuss.User
  plug Ueberauth

  def callback(conn, params) do
    auth = conn.assigns.ueberauth_auth
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)
    sign_in(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case User.insert_or_update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in successfully!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Error logging in: #{reason}")
        |> redirect(to: topic_path(conn, :index))
    end
  end
end
