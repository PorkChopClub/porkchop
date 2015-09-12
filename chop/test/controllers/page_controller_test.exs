defmodule Chop.PageControllerTest do
  use Chop.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "The new PorkChop.club is coming soon!"
  end
end
