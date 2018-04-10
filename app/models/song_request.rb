class SongRequest < ApplicationRecord
  validates :track_name, presence: :true
  validates :response_url, presence: :true
  after_create { RequestSongsJob.perform_later(track_name, response_url) }
end
