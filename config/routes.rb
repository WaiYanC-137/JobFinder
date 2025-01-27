Rails.application.routes.draw do

   root 'home#index'

   get 'home', to: 'home#index'
   get 'register', to: 'home#register'
   get 'contact', to: 'pages#contact'

end
