Rails.application.routes.draw do

  root 'home#index'

  get 'home', to: 'home#index'
  get 'register', to: 'home#register'
  get 'contact', to: 'pages#contact'

  # User Authentication
  resources :m_users


  # Company Authentication
  resources :m_companies




  #Users and Companies Logout (shared)
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

end
