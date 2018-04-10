require 'active_support/core_ext/hash/compact'
require 'active_support/core_ext/module'

class ExternalApiRequest
  include HTTMultiParty

  format :json

  # Constants
  RESPONSE_BODY_LOG_MAX_CHARACTER_COUNT = 200
  BLACKLISTED_LOG_KEYS = %w(
    access_token
    APPLICATION_TOKEN
    Authorization
    authToken
    client_secret
    key
    password
    USER_TOKEN
    X-CLIENT-KEY
    X-CLIENT-SECRET
  )

  # Delegates
  delegate :key?, :parsed_response, :success?, to: :api_response

  def initialize(base_uri:, http_method:, options: {}, path: nil, skip_logging_on_success: false)
    @base_uri = base_uri.chomp('/')
    @http_method = http_method
    @options = format_options(options)
    @path = path
    @skip_logging_on_success = skip_logging_on_success

    @api_response = make_and_log_request
  end

  def response_body
    api_response.body
  end

  def response_code
    api_response.code
  end

  def response_headers
    api_response.headers
  end

  private

  attr_reader :api_response, :base_uri, :http_method, :options, :path, :skip_logging_on_success

  def absolute_path
    if path
      relative_path = path.start_with?('/') ? path[1..-1] : path
      [base_uri, relative_path].join('/')
    else
      base_uri
    end
  end

  def format_options(options)
    {
      basic_auth: options[:basic_auth],
      body: options[:body],
      detect_mime_type: options[:detect_mime_type],
      headers: options[:headers],
      query: options[:query],
      timeout: options[:timeout]
    }.compact
  end

  def log_request_and_response(httparty_response)
    truncated_response_body = nil

    unless httparty_response.internal_server_error?
      truncated_response_body = httparty_response.body&.
        truncate(RESPONSE_BODY_LOG_MAX_CHARACTER_COUNT)
    end

    message = {
      request: {
        method: http_method.to_s,
        url: absolute_path,
        options: options_with_redactions(options.deep_dup)
      },
      response: {
        code: httparty_response.code,
        body: truncated_response_body
      }
    }

    Rails.logger.info(message.to_json)
  end

  def make_and_log_request
    self.class.public_send(http_method, absolute_path, options).tap do |httparty_response|
      unless skip_logging_on_success && httparty_response.success?
        log_request_and_response(httparty_response)
      end
    end
  end

  def options_with_redactions(options_to_redact)
    options_to_redact.each do |key, value|
      if BLACKLISTED_LOG_KEYS.include?(key.to_s)
        options_to_redact[key] = 'REDACTED'
      elsif value.is_a?(Hash)
        options_to_redact[key] = options_with_redactions(value)
      end
    end

    options_to_redact
  end
end
