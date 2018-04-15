class Api::BaseController < ApplicationController
  before_action :authorize_request
  skip_before_action :verify_authenticity_token

  respond_to :json

  private

  def authorize_request
    unless valid_request?
      head(:unauthorized)
    end
  end

  def authorization_token
    Settings.slack_api.authorization_token
  end

  def valid_request?
    params[:token] == authorization_token
  end
end
