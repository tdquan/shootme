Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"

  # ROOT
  root to: 'pages#landing_page'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  devise_scope :user do
    get '/users/:user_id', to: "users/registrations#show", as: :user
  end

  get '/users/:user_id/gallery/:topic_name', to: "albums#render_gallery", as: :render_gallery

  resources :users, only: :index do
    resources :bookings do
      resources :reviews
    end
    resources :requests
    resources :conversations do
      resources :messages
    end

    resources :gallery, controller: :albums
  end

  get 'home', to: "pages#home"
  get 'search', to: "search#search", as: :search
  get 'payment', to: "pages#payment"
  get 'inbox', to: "users#inbox", as: :inbox
  post 'mailer', to: "pages#contact_mailer", as: :contact

  resources :charges
end
