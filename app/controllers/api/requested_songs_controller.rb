class Api::RequestedSongsController < Api::BaseController
  def create
    @song_request = SongRequest.create(track_name: params[:text], response_url: params[:response_url])
  end

  private

  def song_request_params
    params.permit(:text, :response_url)
  end
end
