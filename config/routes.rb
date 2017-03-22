Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :players

  root to: 'home#index'

  post 'play', to: 'activations#activate'
  delete 'play', to: 'activations#deactivate'

  resources :scoreboards, only: :show

  resources :players, only: [:index, :show] do
    resources :matches, controller: "player_matches", only: :index
  end
  resources :seasons, only: [:show]

  namespace :api do
    namespace :v2 do
      resources :players, only: :index

      resources :tables, only: [] do
        resources :active_players, only: [:index, :destroy, :create]

        resources :matches, only: [] do
          collection do
            get :ongoing
            post :setup
          end
        end
      end
    end

    put "table/home_button"
    put "table/away_button"
    put "table/center_button"
  end
end
