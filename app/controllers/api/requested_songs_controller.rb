class Api::RequestedSongsController < Api::BaseController
  def create
    @song_request = SongRequest.create(track_name: params[:text])
  end

  private

  def song_request_params
    params.permit(:text)
  end
end
