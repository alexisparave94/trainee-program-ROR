# frozen_string_literal: true

# Service object to oauth registration
class OauthRegistration < ApplicationService
  def initialize(params)
    @params = params
    super()
  end

  def call
    registration
  end

  def registration
    user_data = set_facebook_data

    @user = User.new(email: user_data[:email],
                     password: Faker::Internet.password(min_length: 8, max_length: 10, mix_case: true))

    raise(NotValidEntryRecord, parse_errors_api(@user)) unless @user.save

    # create access token for the user, so the user won't need to login again after registration
    @access_token = Doorkeeper::AccessToken.create(
      resource_owner_id: @user.id,
      # application_id: client_app.id,
      refresh_token: generate_refresh_token,
      expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
      scopes: ''
    )

    # return json containing access token and refresh token
    # so that user won't need to call login API right after registration
    hash_response
  end

  def set_facebook_data
    facebook_conn = Faraday.new(url: 'https://graph.facebook.com')
    facebook_response = facebook_conn.get('me', { access_token: @params[:facebook_token], fields: 'id,name,email' })
    JSON.parse(facebook_response.body, symbolize_names: true)
  end

  def generate_refresh_token
    loop do
      # generate a random token string and return it,
      # unless there is already another token with the same string
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end

  def hash_response
    {
      user: {
        email: @user.email,
        access_token: @access_token.token,
        token_type: 'Bearer',
        expires_in: @access_token.expires_in,
        refresh_token: @access_token.refresh_token,
        created_at: @access_token.created_at.to_time.to_i
      }
    }
  end
end
