require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, Settings.spotify_api.client_id, Settings.spotify_api.client_secret, scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end
