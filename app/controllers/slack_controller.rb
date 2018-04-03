class SlackController < ActionController::Base
  def song_name
    render text: "Thanks for sending a POST request with cURL! Payload: #{request.body.read}"
  end
end
