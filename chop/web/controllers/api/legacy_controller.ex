defmodule Chop.Api.LegacyController do
  use Chop.Web, :controller

  alias Chop.OngoingGame

  def update_ongoing_match(conn, _params) do
    Chop.OngoingGame.update!
    text conn, ""
  end
end
