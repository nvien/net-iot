class SongRequest < ApplicationRecord
  validates :track_name, presence: :true
  validates :response_url, presence: :true

  after_create { RequestSongsJob.perform_later(track_name, response_url) }
  after_create { post_something(response_url) }


  def post_something(response_url)
    body = {
    "text": "So here are the top 5 tracks we found from your request:",
    "response_type": "in_channel",
    "replace_original": "true",
    "attachments": [
        {
            "text": "Which track would you like to add?",
            "fallback": "You are unable to choose a track",
            "callback_id": "add_song",
            "color": "#E58B22",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "tracks",
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
