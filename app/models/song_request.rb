class SongRequest < ApplicationRecord
  validates :track_name, presence: :true
  validates :response_url, presence: :true

  after_create { RequestSongsJob.perform_later(track_name, response_url) }
  after_create do
    sleep 1.5
    post_something(response_url)
  end

  def post_something(response_url)
    body = {
    "text": "So here are the top 5 tracks matching #{track_name}:",
    "response_type": "in_channel",
    "attachments": [
        {
            "text": "Which track would you like to add?",
            "fallback": "You are unable to choose a track",
            "callback_id": "add_song",
            "color": "#E58B22",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "Track 1 name by Track 1 artist",
                    "text": "Track 1 name - Track 1 artist",
                    "type": "button",
                    "value": "track_uuid chess"
                },
                {
                    "name": "Track 2 name by Track 2 artist",
                    "text": "Track 2 name - Track 2 artist",
                    "type": "button",
                    "value": "maze"
                },
                {
                    "name": "Track 3 name by Track 3 artist",
                    "text": "Track 3 name - Track 3 artist",
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
