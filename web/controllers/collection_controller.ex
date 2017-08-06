defmodule BorrowBee.CollectionController do
  use BorrowBee.Web, :controller

  alias BorrowBee.Collection

  def index(conn, _params) do
    collections = Repo.all(Collection)
    render(conn, "index.html", collections: collections)
  end

  def new(conn, _params) do
    changeset = Collection.changeset(%Collection{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"collection" => collection_params}) do
    changeset = Collection.changeset(%Collection{}, collection_params)

    case Repo.insert(changeset) do
      {:ok, _collection} ->
        conn
        |> put_flash(:info, "Collection created successfully.")
        |> redirect(to: collection_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    collection = Repo.get!(Collection, id)
    render(conn, "show.html", collection: collection)
  end

  def edit(conn, %{"id" => id}) do
    collection = Repo.get!(Collection, id)
    changeset = Collection.changeset(collection)
    render(conn, "edit.html", collection: collection, changeset: changeset)
  end

  def update(conn, %{"id" => id, "collection" => collection_params}) do
    collection = Repo.get!(Collection, id)
    changeset = Collection.changeset(collection, collection_params)

    case Repo.update(changeset) do
      {:ok, collection} ->
        conn
        |> put_flash(:info, "Collection updated successfully.")
        |> redirect(to: collection_path(conn, :show, collection))
      {:error, changeset} ->
        render(conn, "edit.html", collection: collection, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    collection = Repo.get!(Collection, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(collection)

    conn
    |> put_flash(:info, "Collection deleted successfully.")
    |> redirect(to: collection_path(conn, :index))
  end
end
