Rails.application.routes.draw do

  root 'home#index'

  get 'home', to: 'home#index'
  get 'register', to: 'home#register'
  get 'userlist', to: 'home#userlist'
  get 'joblist', to: 'home#joblist'

  # User Authentication
  resources :m_users
  get 'edit_password_user', to: 'm_users#edit_password_user'
  patch 'update_password_user', to: 'm_users#update_password_user'

  resources :t_job_offers

  # Company Authentication
  resources :m_companies
   get 'edit_password_company', to: 'm_companies#edit_password'
  patch 'update_password_company', to: 'm_companies#update_password'




  #Users and Companies Logout (shared)
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
