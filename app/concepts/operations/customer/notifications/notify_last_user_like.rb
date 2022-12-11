# frozen_string_literal: true

module Operations
  module Customer
    module Notifications
      # Class to manage operation of create a commnet of a product
      class NotifyLastUserLike < Trailblazer::Operation
        step :set_order_lines
        step :define_products_per_user
        step :send_notifications

        def set_order_lines(ctx, order:)
          ctx[:order_lines] = order_lines_which_products_reaches_3_of_stock(order)
        end

        def define_products_per_user(ctx, order_lines:, **)
          ctx[:products_user_liked] = {}
          order_lines.includes(product: { likes: :user }).each do |line|
            likes = LastUserLikedProductQuery.new({}, line).likes_of_product_in_order_line
            next if likes.empty?

            ctx[:user] = LastUserLikedProductQuery.new({}, likes).last_user_liked
            save_product_per_user(line, ctx[:user], ctx[:products_user_liked])
          end
        end

        def send_notifications(_ctx, products_user_liked:, **)
          products_user_liked.each do |email, products|
            NotifyLastUserLikedJob.perform_later({ email:, products: })
          end
        end
        
        # def initialize(order)
        #   @order = order
        #   @products_user_liked = {}
        #   super()
        # end
    
        # def call
        #   @order_lines = order_lines_which_products_reaches_3_of_stock
        #   define_products_per_user
        #   @products_user_liked.each do |email, products|
        #     NotifyLastUserLikedJob.perform_later({ email:, products: })
        #   end
        # end

        private

        def order_lines_which_products_reaches_3_of_stock(order)
          order.order_lines.includes(:product).where('products.stock': ..3)
        end

        def save_product_per_user(line, user, products_user_liked)
          if products_user_liked[user.email]
            products_user_liked[user.email] << line.product
          else
            products_user_liked[user.email] = [line.product]
          end
        end
      end
    end
  end
end
