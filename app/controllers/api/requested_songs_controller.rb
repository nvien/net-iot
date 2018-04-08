class Api::RequestedSongsController < Api::BaseController
  def create
    @song_request = SongRequest.create(song_request_params)
  end

  private

  def song_request_params
    params.permit(:track_name)
  end
end
