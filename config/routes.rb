Rails.application.routes.draw do
  match '/song_name' => 'slack#song_name', via: :post
end
