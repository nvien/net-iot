class RequestSongsJob < ApplicationJob
  queue_as :default

  def perform(track_name, response_url)
    tracks = spotify_client.get_tracks(track_name)[0..4]

    Rails.logger(tracks)
    # body = {
    # "text": "Would you like to play a game?",
    # "attachments": [
    #     {
    #         "text": "Choose a game to play",
    #         "fallback": "You are unable to choose a game",
    #         "callback_id": "wopr_game",
    #         "color": "#3AA3E3",
    #         "attachment_type": "default",
    #         "actions": [
    #             {
    #                 "name": "song",
    #                 "text": "Chess",
    #                 "type": "button",
    #                 "value": "trackstrack_id"
    #             },
    #             {
    #                 "name": "game",
    #                 "text": "Falken's Maze",
    #                 "type": "button",
    #                 "value": "maze"
    #             },
    #             {
    #                 "name": "game",
    #                 "text": "Thermonuclear War",
    #                 "style": "danger",
    #                 "type": "button",
    #                 "value": "war",
    #                 "confirm": {
    #                     "title": "Are you sure?",
    #                     "text": "Wouldn't you prefer a good game of chess?",
    #                     "ok_text": "Yes",
    #                     "dismiss_text": "No"
    #                 }
    #             }
    #         ]
    #     }
    # ]
    # }

    ExternalApiRequest.new(http_method: :post, base_uri: response_url, options: {body: name})
  end

  private

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end
end
