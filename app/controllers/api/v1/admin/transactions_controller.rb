# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Class to manage interactions between admin user and comments for a product or a user
      class TransactionsController < ApiController
        before_action :authorize_request

        def index
          @transactions = Admins::TransactionApiService.call(@current_user)
          render json: json_api_format(TransactionRepresenter.for_collection.new(@transactions), 'transactions'), status: :ok
        end
      end
    end
  end
end
