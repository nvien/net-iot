class Api::RequestedSongsController < Api::BaseController
  def create
    # @song_request = SongRequest.create(track_name: params[:text], response_url: params[:response_url])
    track_name = params[:text]
    response_url = params[:response_url]

    @tracks = spotify_client.get_tracks(track_name)

    body = {
    "text": "Would you like to play a game?",
    "attachments": [
        {
            "text": "Choose a game to play",
            "fallback": "You are unable to choose a game",
            "callback_id": "wopr_game",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "game",
                    "text": "Chess",
                    "type": "button",
                    "value": "chess"
                },
                {
                    "name": "game",
                    "text": "Falken's Maze",
                    "type": "button",
                    "value": "maze"
                },
                {
                    "name": "game",
                    "text": "Thermonuclear War",
                    "style": "danger",
                    "type": "button",
                    "value": "war",
                    "confirm": {
                        "title": "Are you sure?",
                        "text": "Wouldn't you prefer a good game of chess?",
                        "ok_text": "Yes",
                        "dismiss_text": "No"
                    }
                }
            ]
        }
    ]
}

    ExternalApiRequest.new(base_uri: response_url, http_method: :post, options: { body: body })


  end

  private

  def song_request_params
    params.permit(:text, :response_url)
  end

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end


end
