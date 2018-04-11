class SongRequest < ApplicationRecord
  validates :track_name, presence: :true
  validates :response_url, presence: :true

  after_create { RequestSongsJob.perform_later(track_name, response_url) }
  after_create { post_something(response_url) }


  def post_something(response_url)
    ExternalApiRequest.new(http_method: :post, base_uri: response_url, options: {body: 'foo'})
  end
end
