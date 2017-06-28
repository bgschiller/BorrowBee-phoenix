defmodule BorrowBee.PageController do
  use BorrowBee.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
