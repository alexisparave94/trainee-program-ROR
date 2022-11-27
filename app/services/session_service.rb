# frozen_string_literal: true

# Service object to get the user's rate of a commentable object
class SessionService < ApplicationService
  def initialize(params)
    @user = User.find_by(email: params[:email])
    @password = params[:password]
    super()
  end

  def call
    authenticate_user
  end

  private

  def authenticate_user
    raise(NotAuthorizeUser, 'Your account has been disabled') if @user.discarded?
    raise(NotAuthorizeUser, 'Invalid credentials') unless @user.valid_password?(@password)

    token = JwtEncoder.call(user_id: @user.id)
    [token, @user]
  end
end
