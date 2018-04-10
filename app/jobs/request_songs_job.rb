class RequestSongsJob < ApplicationJob
  queue_as :default

  def perform(track_name, response_url)
    tracks = spotify_client.get_tracks(track_name)
    name = tracks.first.name
  end

  private

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end
end
