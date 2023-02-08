defmodule AtmAppWeb.PageController do
  use AtmAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
