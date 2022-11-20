# frozen_string_literal: true

module Customer
  module OrderLines
    # Service object to create an order line
    class NewFormGetter < ApplicationService
      def initialize(params)
        @params = params
        super()
      end

      def call
        @order_line_form = Forms::OrderLineForm.new(@params)
      end
    end
  end
end
