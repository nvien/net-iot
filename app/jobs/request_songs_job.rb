class RequestSongsJob < ApplicationJob
  queue_as :default

  def perform(track_name, response_url)
    # tracks = spotify_client.get_tracks(track_name)
    # name = tracks.first.name

    ExternalApiRequest.new(http_method: :post, base_uri: response_url, options: {body: 'foo'})
  end

  private

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end
end
