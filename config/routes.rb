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
  get 'loginforusers', to: 'sessions#new', defaults: { type: "user" }
  post 'loginforusers', to: 'sessions#create', defaults: { type: "user" }

  # Company Authentication
  get 'signupforcompanies', to: 'm_companies#new'
  post 'signupforcompanies', to: 'm_companies#create'
  get 'loginforcompanies', to: 'sessions#new', defaults: { type: "company" }
  post 'loginforcompanies', to: 'sessions#create', defaults: { type: "company" }

  #Users and Companies Logout (shared)
  delete 'logout', to: 'sessions#destroy'

end
