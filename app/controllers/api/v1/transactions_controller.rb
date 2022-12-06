# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions
    class TransactionsController < ApiController
      before_action :authorize_request

      def index
        @transactions = Customer::TransactionApiService.call(@current_user)
        render json: json_api_format(TransactionRepresenter.for_collection.new(@transactions), 'transactions'),
               status: :ok
      end
    end
  end
end
