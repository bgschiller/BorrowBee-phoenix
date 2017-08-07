defmodule BorrowBee.UserData do
  use BorrowBee.Web, :controller
  alias BorrowBee.{User, Item, Collection, Community}

  def show_user(user_id) do
    first_5_items = from b in Item, where: b.user_id == ^user_id, limit: 5
    user = Repo.get!(User, user_id)

    collections_q = from c in Collection,
      where: c.user_id == ^user_id,
      preload: [items: ^first_5_items]
    collections = Repo.all(collections_q)
    items = Repo.all(first_5_items)
    %{
      user: user, collections: collections, items: items,
      communities: get_communities(user),
    }
  end

  def get_communities(user) do
    user.community_ids && Repo.all(
      from c in Community,
      where: c.id in ^user.community_ids)
  end

end
