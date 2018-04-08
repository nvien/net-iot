class SongRequest < ApplicationRecord
  validates :track_name, presence: :true

  after_create { RequestSongsJob.perform_later(track_name) }
end
