# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to create an order line
    class EditFormGetter < ApplicationService
      def initialize(params)
        @params = params
        @order_line = OrderLine.find(params[:id])
        super()
      end

      def call
        raise(StandardError, 'The purchase has been completed') unless @order_line.order.pending?

        @order_line_form = Forms::OrderLineForm.new(id: @params[:id], product_id: @params[:product_id])
      end

      private

      def parse_errors
        @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
      end
    end
  end
end
