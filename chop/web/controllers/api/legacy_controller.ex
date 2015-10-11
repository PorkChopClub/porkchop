defmodule Chop.Api.LegacyController do
  use Chop.Web, :controller

  alias Chop.OngoingGame

  def update_ongoing_match(conn, _params) do
    case OngoingGame.fetch do
      nil ->
        Chop.Endpoint.broadcast!("games:ongoing", "no_game",
                                 %{body: %{}})
      ongoing_game ->
        Chop.Endpoint.broadcast!("games:ongoing", "update",
                                 %{body: ongoing_game})
    end
    text conn, ""
  end
end
