defmodule BorrowBee.Router do
  use BorrowBee.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BorrowBee do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController do
      resources "/sessions", SessionController, only: [:show]
      get "/communities", MembershipController, :list_communities
    end
    resources "/sessions", SessionController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:delete], singleton: true

    resources "/items", ItemController
    resources "/collections", CollectionController, exclude: [:edit, :update, :delete]
    resources "/communities", CommunityController do
      get "/users", MembershipController, :list_users
      post "/users", MembershipController, :join
      delete "/users", MembershipController, :leave
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BorrowBee do
  #   pipe_through :api
  # end
end
