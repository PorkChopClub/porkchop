Rails.application.routes.draw do
  root to: 'home#index'

  resource :scoreboard, only: [:show, :edit]

  resources :matches, only: [:new, :create, :show]

  namespace :api do
    resources :players, only: :index

    resource :ongoing_match, only: [:show, :destroy] do
      put "home_point"
      put "away_point"
      put "rewind"
      put "finalize"
    end

    get "stats/win_percentage"
  end
end
