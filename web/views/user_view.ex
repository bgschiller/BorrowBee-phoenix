defmodule BorrowBee.UserView do
  use BorrowBee.Web, :view

  def gravatar_url(email) do
    hash = :crypto.hash(:md5, email) |> Base.encode16 |> String.downcase
    "//gravatar.com/avatar/#{hash}?s=200&d=retro"
  end
end
