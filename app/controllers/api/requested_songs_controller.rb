class Api::RequestedSongsController < Api::BaseController
  def create
    @tracks = client.get_tracks(request.body.read)

    render text: "##{@tracks}"
  end

  private

  def client
    @client ||= ApiClients::SpotifyClient.new
  end
end
