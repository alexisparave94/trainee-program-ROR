# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to create an order line
    class OrderLineCreator < ApplicationService
      def initialize(params, order)
        @params = params
        @order = order
        super()
      end

      def call
        @order_line_form = Forms::OrderLineForm.new(@params)
        raise(NotValidEntryRecord, parse_errors) unless @order_line_form.valid? && @order.pending?

        add_product
      end

      private

      def parse_errors
        @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
      end

      # Method to add a new order line or if the line exists only sum quantities
      def add_product
        @order_line = @order.order_lines.find_by(product_id: @params[:product_id])
        if @order_line.nil?
          @order_line = OrderLine.create(
            order_id: @order.id,
            product_id: @params[:product_id],
            price: @params[:price],
            quantity: @params[:quantity]
          )
        else
          @order_line.quantity += @params[:quantity].to_i
          @order_line.save
        end
        @order_line
      end
    end
  end
end
