json.(@song_request, :created_at, :track_name)

json.text "Your request for #{@song_request.track_name} has been received!"
