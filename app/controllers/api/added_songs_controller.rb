class Api::AddedSongsController < Api::BaseController
  def create
    # spotify_client.add_track_to_playlist(track)
  end

  private

  def payload
    @payload ||= JSON.parse(params['payload'])
  end

  def callback_id
    payload['callback_id']
  end

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end

  def track
    spotify_client.get_track(params[:track_id])
  end
end
