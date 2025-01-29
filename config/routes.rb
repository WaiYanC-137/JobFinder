Rails.application.routes.draw do
  

   root 'home#index'

   get 'home', to: 'home#index'
   get 'register', to: 'home#register'
   get 'contact', to: 'pages#contact'

  get '/signupforusers', to: 'm_users#new'
  post 'signupforusers', to: 'm_users#create'
  get '/loginforusers', to: 'sessions#new'
  # post '/login', to: 'sessions#create'
  # delete '/logout', to: 'sessions#destroy', as: 'logout'
end
