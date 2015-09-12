defmodule Chop.PageController do
  use Chop.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def scoreboard(conn, _params) do
    render conn, "scoreboard.html"
  end
end
