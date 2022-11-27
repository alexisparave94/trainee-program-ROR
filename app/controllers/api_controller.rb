# frozen_string_literal: true

# Class parent of the api controllers
class ApiController < ActionController::API
  include Pundit::Authorization
  include ErrorHandler
  include Swagger::Blocks
  include SwaggerControllers

  def authorize_request
    @token = request.headers['Authorization']
    header = @token.split.last if @token
    @decoded = JwtDecoder.call(header)
    @current_user = User.find(@decoded[:user_id])
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
end
