module ApiClients
  class SpotifyClient
    def initialize
      authenticate_with_spotify
    end

    def get_tracks(track_name)
      RSpotify::Track.search(track_name)
    end

    private

    def authenticate_with_spotify
      RSpotify.authenticate(client_id, client_secret)
    end

    def client_id
      Settings.spotify_api.client_id
    end

    def client_secret
      Settings.spotify_api.client_secret
    end
  end
end
