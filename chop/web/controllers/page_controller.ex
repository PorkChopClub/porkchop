defmodule Chop.PageController do
  use Chop.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
