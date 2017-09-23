defmodule BorrowBee.ViewHelpers do

  def truncate(s, len \\ 50) do
    cond do
      String.length(s) <= len -> s
      true -> String.slice(s, 0..len) <> "…"
    end
  end

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end
end
