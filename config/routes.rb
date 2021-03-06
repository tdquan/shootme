Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount Attachinary::Engine => "/attachinary"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }

  devise_scope :user do
    get '/users/pro_user_sign_up', to: "users/registrations#new_pro_user", as: :new_pro_user
    post '/users/create_pro', to: 'users/registrations#create_pro', as: :pro_registration
    get '/users/:user_id', to: "users/registrations#show", as: :user
  end


  # ROOT
  scope '(:locale)', locale: /fr|en/ do
    # Edit and modify galleries
    root to: 'pages#landing_page'

    get '/users/:user_id/gallery/:album_id', to: "albums#render_gallery", as: :render_gallery
    get '/users/:user_id/all_galleries', to: "albums#all_galleries", as: :all_galleries
    put '/users/:user_id/gallery/:album_id/delete_photo', to: "albums#delete_photo", as: :delete_photo
    put '/users/:user_id/gallery/:album_id/add_photo', to: "albums#add_photo", as: :add_photo

    # User routes
    get '/users/:user_id/conversations/:conversation_id/refresh_chat', to: "messages#refresh_chat"

    resources :users, only: :index do
      resources :bookings do
        resources :reviews
        put 'user_confirmed', to: "bookings#user_confirmed"
        put 'client_confirmed', to: "bookings#client_confirmed"
      end
      get 'wallet', to: "wallet#index"
      get 'wallet/payment', to: "wallet#payment"
      post 'wallet/top_up', to: "wallet#top_up", as: :wallet_topup
      resources :requests

      resources :conversations do
        resources :messages
      end

      resources :gallery, controller: :albums
    end

    get 'pay_for_booking', to: "pages#pay_for_booking", as: :booking_charge
    resources :charges, only: [:new, :create]

    get 'home', to: "pages#home"
    get 'search', to: "search#search", as: :search
    get 'inbox', to: "users#inbox", as: :inbox
    post 'mailer', to: "pages#contact_mailer", as: :contact
  end
end
