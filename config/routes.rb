Rails.application.routes.draw do
  root to: redirect('scoreboard/show')

  get 'scoreboard/show'

  namespace :api do
    resources :players, only: :index
  end
end
