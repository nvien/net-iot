Rails.application.routes.draw do
  match '/curl_example' => 'request_example#curl_post_example', via: :post
end
