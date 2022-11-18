# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to create an order line
    class OrderLineCreator < ApplicationService
      def initialize(params, user, order = nil)
        @params = params
        @user = user
        @order = order
        super()
      end

      def call
        set_order
        @order_line_form = Forms::OrderLineForm.new(@params)
        raise(NotValidEntryRecord, parse_errors) unless @order_line_form.valid? && @order.pending?

        add_product
      end

      private

      def parse_errors
        @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
      end

      def set_order
        return if @order

        @order = zero_pending_order? ? Order.create(user: @user) : @user.orders.where(status: 'pending').take
      end

      def zero_pending_order?
        @user.orders.where(status: 'pending').empty?
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
