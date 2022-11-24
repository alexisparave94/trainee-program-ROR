# frozen_string_literal: true

module Customer
  # Service object to notify the last user that liked a product when his stock reaches 3
  class LastUserNotifier < ApplicationService
    def initialize(order)
      @order = order
      @products_user_liked = {}
      super()
    end

    def call
      @order_lines = order_lines_which_products_reaches_3_of_stock
      define_products_per_user
      pp @products_user_liked
      @products_user_liked.each do |email, products|
        NotifyLastUserLikedJob.perform_later({ email:, products: })
      end
    end

    private

    attr_reader :order

    def order_lines_which_products_reaches_3_of_stock
      @order.order_lines.includes(:product).where('products.stock': ..3)
    end

    def define_products_per_user
      @order_lines.includes(product: { likes: :user }).each do |line|
        next if line.product.likes.empty?

        @user = line.product.likes.order(created_at: :DESC).take.user
        save_product_per_user
      end
    end

    def save_product_per_user
      if @products_user_liked[@user.email]
        @products_user_liked[@user.email] << line.product
      else
        @products_user_liked[@user.email] = [line.product]
      end
    end
  end
end
