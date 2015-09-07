defmodule Chop.Router do
  use Chop.Web, :router

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

  scope "/", Chop do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Chop do
    pipe_through :api

    post "/ongoing_match", Api.LegacyController, :update_ongoing_match
  end
end
