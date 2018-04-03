class Api::RequestedSongsController < Api::BaseController
  def create
    @tracks = client.get_tracks(params[:track_name])
  end

  private

  def client
    @client ||= ApiClients::SpotifyClient.new
  end
end
