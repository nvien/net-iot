class Api::RequestedSongsController < Api::BaseController
  def create
    @song_request = SongRequest.create(track_name: params[:text], response_url: params[:response_url])

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

    headers = { 'Content-type' => 'application/json' }

    ExternalApiRequest.new(http_method: :post, base_uri: params[:response_url], options: {body: body, headers: headers})
  end

  private

  def song_request_params
    params.permit(:text, :response_url)
  end

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end


end
