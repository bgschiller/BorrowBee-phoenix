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
    end
    resources "/sessions", SessionController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:delete], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", BorrowBee do
  #   pipe_through :api
  # end
end
