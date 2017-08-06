defmodule BorrowBee.UserData do
  use BorrowBee.Web, :controller
  alias BorrowBee.{User, Item, Collection}

  def show_user(user_id) do
    first_5_items = from b in Item, where: b.user_id == ^user_id, limit: 5
    user = Repo.get!(User, user_id)

    collections_q = from c in Collection,
      where: c.user_id == ^user_id,
      preload: [items: ^first_5_items]
    collections = Repo.all(collections_q)
    items = Repo.all(first_5_items)
    %{user: user, collections: collections, items: items}
  end
end
