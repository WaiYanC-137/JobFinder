Rails.application.routes.draw do

  root 'home#index'

  get 'home', to: 'home#index'
  get 'register', to: 'home#register'
  get 'userlist', to: 'home#userlist'
  get 'joblist', to: 'home#joblist'


  # User Authentication
  resources :m_users
  get 'edit_password_user', to: 'm_users#edit_password'
  patch 'update_password_user', to: 'm_users#update_password'
  get 'apply_job_offer/:job_offer_id', to: 'm_users#apply_job_offer', as: 'apply_job_offer'

  resources :t_job_offers

  # Company Authentication
  resources :m_companies
  get 'edit_password_company', to: 'm_companies#edit_password'
  patch 'update_password_company', to: 'm_companies#update_password'

 


  #Users and Companies Logout (shared)
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'


  get '/passwordreset', to: 'password_resets#new'  # Show the form
post '/passwordreset', to: 'password_resets#create'  # Send email
get '/passwordreset/:token/edit', to: 'password_resets#edit', as: 'edit_password_reset' # Show reset form
patch '/passwordreset/:id', to: 'password_resets#update' , as: 'passwordresetupdate' # Handle password update


end
