class Api::RequestedSongsController < Api::BaseController
  before_filter :allow_only_html_requests

  def create
    render json: {
    "response_type": "ephemeral",
    "text": "We found multiple songs, is it any of these?",
    "attachments": [
        {
            "text":"Partly cloudy today and tomorrow"
        }
    ]
}

    @tracks = client.get_tracks(params[:track_name])
  end

  private

  def song_request_params
    params.permit(:track_name)
  end
end
