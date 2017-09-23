defmodule BorrowBee.MembershipController do
  use BorrowBee.Web, :controller

  alias BorrowBee.{Community, User}

  def list_communities(conn, %{"user_id" => user_id}) do
    user = Repo.one(from user in User,
      where: user.id == ^user_id,
      preload: [community_ids: :memberships])
    communities = user.community_ids && Repo.all(
      from c in Community,
      where: c.id in ^user.community_ids)
    render(conn, "index.html", user: user, communities: communities)
  end

  def create(conn, %{"community" => community_params}) do
    changeset = Community.changeset(%Community{}, community_params)

    case Repo.insert(changeset) do
      {:ok, _community} ->
        conn
        |> put_flash(:info, "Community created successfully.")
        |> redirect(to: community_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    community = Repo.get!(Community, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(community)

    conn
    |> put_flash(:info, "Community deleted successfully.")
    |> redirect(to: community_path(conn, :index))
  end
end
