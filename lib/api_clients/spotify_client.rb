module ApiClients
  class SpotifyClient
    def add_track_to_playlist(track)
      resp = playlist.add_tracks!([track])
      Rails.logger.info(resp)
    end

    def get_tracks(track_name)
      RSpotify::Track.search(track_name)
    end

    def get_track(track_id)
      RSpotify::Track.find(track_id)
    end

    private

    def playlist
      @playlist ||= RSpotify::Playlist.find(user.id, playlist_id)
    end

    def playlist_id
      Settings.spotify_api.playlist_id
    end

    def spotify_user_id
      Settings.spotify_api.user_id
    end

    def user
      local_user = User.find(spotify_user_id)
      RSpotify::User.new(local_user.spotify_credentials)
    end
  end
end
