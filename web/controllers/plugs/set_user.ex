defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
  end

  def call(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        assign(conn, :user, nil)
      user_id ->
        user = Repo.get(User,user_id)
        assign(conn, :user, user)
    end
  end
end