Rails.application.routes.draw do
  root to: 'pages#landing_page'

  devise_for :users

  devise_scope :user do
    get '/users/:id/show', to: "devise/registrations#show"
  end

  resources :users, only: :index do
    resources :bookings
  end

  get 'home', to: "pages#home"
  get 'search', to: "search#search"
end
