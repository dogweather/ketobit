defmodule Ketobit.Router do
  use Ketobit.Web, :router

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

  scope "/", Ketobit do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
  end

  scope "/auth", MyApp do
    pipe_through :browser
    get "/", AuthController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Ketobit do
  #   pipe_through :api
  # end
end
