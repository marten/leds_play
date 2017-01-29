defmodule LedsPlay.PageController do
  use LedsPlay.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
