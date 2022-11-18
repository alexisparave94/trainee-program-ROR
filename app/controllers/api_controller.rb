# frozen_string_literal: true

# Class parent of the api controllers
class ApiController < ActionController::API
  include Pundit::Authorization
  include ErrorHandler
  include Pagy::Backend

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def paginate(collection, items = 20)
    @pagy, @result = pagy(collection, items:)
  end

  def json_api_format(representer, type, pagy = nil)
    if pagy
      { meta: {
          pagination: { page: pagy.page,limit: pagy.items, total_items: pagy.count,
                        total_pages: pagy.pages,
                        prev_page: pagy.prev,
                        next_page: pagy.next,
                        last_page: pagy.last }
        },
        data: { type => representer } }
    else
      { data: { type => representer } }
    end
  end
end
