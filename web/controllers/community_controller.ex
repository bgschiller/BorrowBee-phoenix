defmodule BorrowBee.CommunityController do
  use BorrowBee.Web, :controller

  alias BorrowBee.Community

  def index(conn, _params) do
    communities = Repo.all(Community)
    render(conn, "index.html", communities: communities)
  end

  def new(conn, _params) do
    changeset = Community.changeset(%Community{})
    render(conn, "new.html", changeset: changeset)
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

  def show(conn, %{"id" => id}) do
    community = Repo.get!(Community, id)
    render(conn, "show.html", community: community)
  end

end
