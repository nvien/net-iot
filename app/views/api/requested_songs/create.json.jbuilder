json.(@song_request, :created_at, :track_name)

json.response_type 'in_channel'
json.text "Your request for #{@song_request.track_name} has been received!"
