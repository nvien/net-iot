class UsersController < ApplicationController
  def new
  end

  def spotify
    User.create(spotify_credentials: request.env['omniauth.auth'])
  end
end
