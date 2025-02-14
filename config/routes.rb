Rails.application.routes.draw do

  root 'home#index'

  get 'home', to: 'home#index'
  get 'register', to: 'home#register'
  get 'userlist', to: 'home#userlist'
  get 'joblist', to: 'home#joblist'

  # User Authentication
  resources :m_users

  resources :t_job_offers

  # Company Authentication
  resources :m_companies




  #Users and Companies Logout (shared)
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

end
