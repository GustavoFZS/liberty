# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      post '/users', to: 'users#signup'
      post '/users/signin', to: 'users#signin'
      put '/users', to: 'users#update'
      get '/users', to: 'users#show'
    end
  end
end
