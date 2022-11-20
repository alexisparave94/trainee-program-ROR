# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to create an order line
    class EditFormGetter < ApplicationService
      def initialize(params, user = nil)
        @params = params
        @order_line = params[:id] && OrderLine.find(params[:id])
        @user = user
        super()
      end

      def call
        raise(StandardError, 'The purchase has been completed') unless !@user || @order_line.order.pending?

        @order_line_form = Forms::OrderLineForm.new(@params)
      end

      private

      def parse_errors
        @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
      end
    end
  end
end
