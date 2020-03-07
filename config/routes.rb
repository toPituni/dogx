Rails.application.routes.draw do
  get 'schedules/new'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/map', to: "journeys#map"
  resources :dogs do
    resources :schedules, only: [:update, :create]
  end
  resources :owners, only: [:create, :update]
  # routes for walks
  get  "/walks/:date", to: "walks#schedule", as: "walks_schedule"
  resources :slots, only: [:new,:create]


end







