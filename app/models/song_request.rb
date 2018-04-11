class SongRequest < ApplicationRecord
  validates :track_name, presence: :true
  validates :response_url, presence: :true

  after_create { RequestSongsJob.perform_later(track_name, response_url) }
  after_create { post_something(response_url) }


  def post_something(response_url)
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
                    "name": "song",
                    "text": "Chess",
                    "type": "button",
                    "value": "trackstrack_id"
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
    }.to_json

    ExternalApiRequest.new(http_method: :post, base_uri: response_url, options: {body: body})
  end
end
