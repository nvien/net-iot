class Api::AddedSongsController < Api::BaseController
  def create
    spotify_client.add_track_to_playlist(track)
    # @track_name = track_name
  end

  private

  def payload
    @payload ||= JSON.parse(params['payload'])
  end

  def track_id
    payload['actions'].first['value']
  end

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end

  def track
    @track ||= spotify_client.get_track(track_id)
  end
end
