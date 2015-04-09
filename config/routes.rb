Rails.application.routes.draw do
  root to: 'home#index'

  resource :scoreboard, only: [:show, :edit]
  resource :activation, only: [:edit]

  resources :matches, only: [:index, :show, :new, :create]
  resources :players, only: [:index, :show, :edit, :update]

  get 'signin', to: redirect('/auth/twitter')
  delete 'signout', to: 'sessions#destroy', as: 'signout'

  get 'auth/:provider/callback', to: 'sessions#create'
  post 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  namespace :api do
    resources :players, only: :index
    resources :achievements, only: :index

    resource :ongoing_match, only: [:show, :destroy] do
      put "home_point"
      put "away_point"
      put "toggle_service"
      put "rewind"
      put "finalize"
    end

    resources :activations, only: [:index]

    get "stats/win_percentage"
    get "stats/rating"

    put "table/home_button"
    put "table/away_button"
    put "table/center_button"
  end
end
