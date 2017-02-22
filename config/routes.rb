Rails.application.routes.draw do
  root to: 'pages#landing_page'

  # devise_for :users, controllers: { registrations: 'users/registrations' }
  # devise_for :users, only: [:omniauth_callbacks, :registrations], controllers: {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations'}
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  devise_scope :user do
    get '/users/:user_id', to: "users/registrations#show", as: :user
  end

  resources :users, only: :index do
    resources :bookings
    resources :requests
    resources :conversations do
      resources :messages
    end
  end

  get 'home', to: "pages#home"
  get 'search', to: "search#search"
  get 'payment', to: "pages#payment"
  get '/users/:user_id/inbox', to: "users#inbox"

  resources :charges
end
