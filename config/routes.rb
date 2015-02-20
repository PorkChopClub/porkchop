Rails.application.routes.draw do
  root to: 'home#index'

  resource :scoreboard, only: [:show, :edit]
  resources :matches, only: [:index, :show, :new, :create]
  resources :players, only: [:index, :show, :edit, :update]

  namespace :api do
    resources :players, only: :index
    resource :ongoing_match, only: [:show, :destroy] do
      put "home_point"
      put "away_point"
      put "toggle_service"
      put "rewind"
      put "finalize"
    end

    get "stats/win_percentage"
  end
end
