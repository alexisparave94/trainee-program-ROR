# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to update an order line
    class OrderLineUpdater < ApplicationService
      class NotValidEntryRecord < StandardError; end

      def initialize(params, order)
        @params = params
        @order = order
        @order.order_lines
        @order_line = @order.order_lines.find_by(product_id: @params[:product_id])
        super()
      end

      def call
        @order_line_form = Forms::OrderLineForm.new(@params)
        raise(NotValidEntryRecord, parse_errors) unless @order_line_form.valid?

        @order_line.update(quantity: @params[:quantity])
        @order_line
      end

      private

      def parse_errors
        @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
      end
    end
  end
end
