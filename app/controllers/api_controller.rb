# frozen_string_literal: true

# Class parent of the api controllers
class ApiController < ActionController::API
  include Pundit::Authorization
  include ErrorHandler
  include Swagger::Blocks
  include SwaggerControllers

  def authorize_request
    header = request.headers['Authorization']
    @token = header.split.last if header
    if Doorkeeper::AccessToken.find_by(token: @token)
      authorize_doorkeeper
    else
      authorize_jwt
    end
  end

  def json_api_format(representer, type, pagy = nil)
    if pagy
      { data: { type => representer },
        meta: {
          pagination: { page: pagy.page, limit: pagy.items, total_items: pagy.count,
                        total_pages: pagy.pages,
                        prev_page: pagy.prev,
                        next_page: pagy.next,
                        last_page: pagy.last }
        } }
    else
      { data: { type => representer } }
    end
  end

  def authorize_jwt
    ctx = run Operations::Auth::Jwt::TokenDecode, token: @token
    @current_user = User.find(ctx[:token_decoded][:user_id])
  end

  def authorize_doorkeeper
    obj_token = Doorkeeper::AccessToken.find_by(token: @token)
    raise(NotAuthorizeUser, 'Access token revoked') if obj_token.revoked?

    raise(NotAuthorizeUser, 'Access token expired') if obj_token.expired?

    @current_user = User.find(obj_token.resource_owner_id)
  end
end
