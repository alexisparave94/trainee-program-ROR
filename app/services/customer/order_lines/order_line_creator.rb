# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to create an order line
    class OrderLineCreator < ApplicationService
      def initialize(params, user, order = nil, token = nil)
        @params = params
        @user = user
        @order = order
        @token = token
        super()
      end

      def call
        set_order
        @order_line_form = Forms::OrderLineForm.new(@params)
        new_order unless @order.pending?
        handle_error

        add_product
      end

      private

      def parse_errors
        @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
      end

      def parse_errors_api
        @order_line_form.errors.messages
      end

      def new_order
        @order = Order.create(user: @user)
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

      def handle_error
        if @token
          raise(NotValidEntryRecord, parse_errors_api) unless @order_line_form.valid?
        else
          raise(StandardError, parse_errors) unless @order_line_form.valid?
        end
      end
    end
  end
end
