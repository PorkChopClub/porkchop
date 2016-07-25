Rails.application.routes.draw do
  devise_for :players
  root to: 'home#index'

  resource :scoreboard, only: [:show, :edit]
  resources :scoreboards, only: :show

  resources :matches, only: [:index, :show]
  resources :players, only: [:index, :show] do
    resources :matches, controller: "player_matches", only: :index
  end
  resources :seasons, only: [:show]

  namespace :api do
    resources :players, only: :index
    resources :achievements, only: :index

    resource :ongoing_match, only: [:show, :destroy] do
      put "home_point"
      put "away_point"
      put "toggle_service"
      put "rewind"
      put "finalize"
      put "matchmake"
    end

    resource :matchmaking, only: [:show]

    resources :activations, only: [:index] do
      member do
        put "activate"
        put "deactivate"
      end
    end

    get "stats/win_percentage"
    get "stats/rating"

    put "table/home_button"
    put "table/away_button"
    put "table/center_button"
  end
end
