Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get '/users/:id/show', to: "devise/registrations#show"
  end

  root to: 'pages#landing_page'
  get '/home', to: "pages#home"

  resources :bookings
end
