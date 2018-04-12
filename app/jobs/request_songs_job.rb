class RequestSongsJob < ApplicationJob
  queue_as :default

  def perform(track_name, response_url)
    @tracks = spotify_client.get_tracks(track_name)[0..4]

    post_back_to_slack(response_url)
  end

  private

  def construct_body
    {
    "text": "So here are the top 5 tracks we found from your request:",
    "response_type": "in_channel",
    "attachments": [
        {
            "text": "Which track would you like to add?",
            "fallback": "You are unable to choose a track",
            "callback_id": "add_track",
            "color": "#E58B22",
            "attachment_type": "default",
            "actions": [
                {
                    "name": "#{@tracks[0].name} by #{@tracks[0].artists.first.name}",
                    "text": "#{@tracks[0].name} - #{@tracks[0].artists.first.name}",
                    "type": "button",
                    "value": "#{@tracks[0].uri}"
                }
                # {
                #     "name": "#{@tracks[1].first.name} by #{@tracks[1].artists.first.name}",
                #     "text": "#{@tracks[1].first.name} - #{@tracks[1].artists.first.name}",
                #     "type": "button",
                #     "value": "#{@tracks[1].track_id}"
                # },
                # {
                #     "name": "#{@tracks[2].name} by #{@tracks[2].artist.name}",
                #     "text": "#{@tracks[2].name} - #{@tracks[2].artist.name}",
                #     "type": "button",
                #     "value": "#{@tracks[2].track_id}"
                # },
                # {
                #     "name": "#{@tracks[3].name} by #{@tracks[3].artist.name}",
                #     "text": "#{@tracks[3].name} - #{@tracks[3].artist.name}",
                #     "type": "button",
                #     "value": "#{@tracks[3].track_id}"
                # },
                # {
                #     "name": "#{@tracks[4].name} by #{@tracks[4].artist.name}",
                #     "text": "#{@tracks[4].name} - #{@tracks[4].artist.name}",
                #     "type": "button",
                #     "value": "#{@tracks[4].track_id}"
                # }
            ]
        }
    ]
    }.to_json
  end

  def no_tracks_received
    {
      'text': "We couldn't find the track on spotify :( Try again?",
      'response_type': 'in_channel'
    }
  end

  def spotify_client
    @spotify_client ||= ApiClients::SpotifyClient.new
  end

  def post_back_to_slack(response_url)
    if @tracks.nil?      ### what happens when we request a non-existant track? unlikely that it returns nil.
      ExternalApiRequest.new(http_method: :post, base_uri: response_url, options: { body: no_tracks_received })
    else
      ExternalApiRequest.new(http_method: :post, base_uri: response_url, options: { body: construct_body })
    end
  end
end
