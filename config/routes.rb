Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  root to: "pages#welcome"
  resource :profile, only: [:show, :update]
  get '/strava/callback', to: 'strava#callback'
  get '/strava/connect', to: 'strava#connect'

  resources :running_sessions, only: :show

  resources :programs, only: [:show, :new, :create, :edit, :update] do
    member do
      get :recap
      resources :running_sessions, only: [:index, :edit, :update]
    end
  end



  get "/home", to: "pages#home", as: "home"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
