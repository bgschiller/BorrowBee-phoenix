defmodule BorrowBee.ItemController do
  use BorrowBee.Web, :controller

  alias BorrowBee.Item

  import Ecto.Changeset, only: [put_assoc: 3]

  plug :scrub_params, "item" when action in [:create, :update]
  plug :must_be_logged_in when action in [:new, :create]
  plug :assign_item_and_authorize_user when action in [:update, :edit, :delete]

  def index(conn, _params) do
    items = Repo.all(Item) |> Repo.preload(:user)
    render(conn, "index.html", items: items)
  end

  def new(conn, _params) do
    changeset = Item.changeset(%Item{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    changeset = Item.changeset(%Item{}, item_params)
      |> put_assoc(:user, get_session(conn, :current_user))
    case Repo.insert(changeset) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: item_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    render(conn, "show.html", item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item)
    render(conn, "edit.html", item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Repo.get!(Item, id)
    changeset = Item.changeset(item, item_params)

    case Repo.update(changeset) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: item_path(conn, :show, item))
      {:error, changeset} ->
        render(conn, "edit.html", item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Repo.get!(Item, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: item_path(conn, :index))
  end

  defp must_be_logged_in(conn, _opts) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to create an item!")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end


  defp item_not_found(conn) do
    conn
    |> put_flash(:error, "Item not found!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end

  defp assign_item(conn) do
    case conn.params do
      %{"id" => item_id} ->
        case Repo.get(Item, item_id) do
          nil -> item_not_found(conn)
          item -> assign(conn, :item, item)
        end
      _ -> item_not_found(conn)
    end
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    (user && (user.id == conn.assigns[:item].user_id || BorrowBee.Auth.is_admin?(user)))
  end

  defp assign_item_and_authorize_user(conn, _opts) do
    conn = assign_item(conn)
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that item!")
      |> redirect(to: item_path(conn, :index))
      |> halt()
    end
  end

end
