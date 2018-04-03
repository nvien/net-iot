Rails.application.routes.draw do
  namespace :api do
    resources :requested_songs, only: :create
  end

  match '/song_name' => 'slack#song_name', via: :post
end
