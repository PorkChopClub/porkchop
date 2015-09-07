defmodule Chop.Api.LegacyController do
  use Chop.Web, :controller

  def update_ongoing_match(conn, params) do
    Chop.Endpoint.broadcast!("games:ongoing", "update", %{body: params})
    text conn, ""
  end
end
