Rails.application.routes.draw do
  mount Attachinary::Engine => "/attachinary"

  # ROOT
  root to: 'pages#landing_page'

  # DEVISE
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get '/users/:user_id', to: "users/registrations#show", as: :user
  end

  resources :users, only: :index do
    resources :bookings
    resources :requests
    resources :conversations do
      resources :messages
    end

    resources :gallery, controller: :albums
  end

  get 'home', to: "pages#home"
  get 'search', to: "search#search"
  get 'payment', to: "pages#payment"

  resources :charges
end
