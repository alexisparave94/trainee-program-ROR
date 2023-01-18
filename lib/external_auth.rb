# frozen_string_literal: true

module ExternalAuth
  # Class to authenticate with google provider
  class Google
    GOOGLE_URI = 'https://oauth2.googleapis.com'
    GOOGLE_URI_USER_INFO = 'https://www.googleapis.com/userinfo/v2'

    def initialize(token)
      @token = token
      @user_data = user_data
    end

    def fetch_access_token
      google_conn = Faraday.new(
        url: GOOGLE_URI,
        headers: { 'Content-Type' => 'application/json' }
      )
      params = {
        client_id: ENV.fetch('GOOGLE_CLIENT_ID'),
        client_secret: ENV.fetch('GOOGLE_CLIENT_SECRET'),
        redirect_uri: ENV.fetch('REDIRECT_GOOGLE_URI'),
        grant_type: 'authorization_code',
        code: @token
      }

      google_response = google_conn.post('token') do |req|
        req.body = params.to_json
      end
      data = JSON.parse(google_response.body, symbolize_names: true)
      data[:access_token]
    end

    def user_data
      access_token = fetch_access_token
      return nil unless access_token

      google_conn = Faraday.new(url: GOOGLE_URI_USER_INFO)
      google_response = google_conn.get('me', { access_token: })
      data = JSON.parse(google_response.body, symbolize_names: true)
      return nil if data[:error]

      User.find_by(email: data[:email])
    end

    def get_user
      @user_data
    end
  end

  # Class to authenticate with facebook provider
  class Facebook
    FACEBOOK_URI = 'https://graph.facebook.com'
    FIELDS = 'id,name,email'

    def initialize(token)
      @token = token
      @user_data = user_data
    end

    def user_data
      facebook_conn = Faraday.new(url: FACEBOOK_URI)
      facebook_response = facebook_conn.get('me', { access_token: @token, fields: FIELDS })
      data = JSON.parse(facebook_response.body, symbolize_names: true)
      return nil if data[:error]

      User.find_by(email: data[:email])
    end

    def get_user
      @user_data
    end
  end
end
