Rails.application.routes.draw do
  get "m_companies/new"
  get "m_companies/create"
  get "m_companies/show"
  get "m_companies/edit"
  get "m_companies/update"
  get "m_companies/destroy"
  

   root 'home#index'

  get 'home', to: 'home#index'
  get 'register', to: 'home#register'
  get 'contact', to: 'pages#contact'

  # User Authentication
  get 'signupforusers', to: 'm_users#new'
  post 'signupforusers', to: 'm_users#create'

  # Company Authentication
  get 'signupforcompanies', to: 'm_companies#new'
  post 'signupforcompanies', to: 'm_companies#create'

  #Users and Companies Logout (shared)
  get '/login', to: 'sessions#new', as: 'login'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

end
