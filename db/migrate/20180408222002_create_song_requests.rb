class CreateSongRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :song_requests do |t|
      t.timestamps
      t.string :track_name
    end
  end
end
