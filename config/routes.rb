require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api do
    resources :requested_songs, only: :create
    resources :added_songs, only: :create
  end

  get '/connect', to: 'users#new'
  get '/auth/spotify/callback', to: 'users#spotify'

  mount Sidekiq::Web => '/sidekiq'
end
