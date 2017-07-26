defmodule BorrowBee.ViewHelpers do

  def truncate(s, len \\ 50) do
    cond do
      String.length(s) <= len -> s
      true -> String.slice(s, 0..len) <> "…"
    end
  end
end
