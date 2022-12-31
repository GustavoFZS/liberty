Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    post '/users', to: 'users#signup'
    post '/users/signin', to: 'users#signin'
    put '/users', to: 'users#update'
    get '/users', to: 'users#show'
  end
end
