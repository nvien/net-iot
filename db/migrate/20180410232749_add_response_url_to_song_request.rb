class AddResponseUrlToSongRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :song_requests, :response_url, :string
  end
end
