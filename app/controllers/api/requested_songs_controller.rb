class Api::RequestedSongsController < Api::BaseController
  # before_filter :allow_only_html_requests

  def create
#     render json: {
#     "response_type": "ephemeral",
#     "text": "We found multiple songs, is it any of these?#{params}",
#     "attachments": [
#         {
#             "text":"Partly cloudy today and tomorrow"
#         }
#     ]
# }

    @song_request = SongRequest.create(track_name: params[:text])
  end

  private

  def song_request_params
    params.permit(:text)
  end
end
