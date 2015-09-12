defmodule Chop.PageControllerTest do
  use Chop.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "The new PorkChop.club is coming soon!"
  end

  test "GET /scoreboard" do
    conn = get conn(), "/scoreboard"
    assert html_response(conn, 200)
  end
end
