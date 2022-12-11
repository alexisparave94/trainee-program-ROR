# frozen_string_literal: true

module Operations
  module Customer
    module Comments
      # Class to manage operation of create a commnet of a product
      class Create < Trailblazer::Operation
        step Model(Comment, :new)
        step Contract::Build(constant: Contracts::Comments::CommentProduct)
        step Contract::Validate(key: :comment)
        step :set_values
        step :persist_rate
        step :persist_comment

        def set_values(ctx, params:, **)
          ctx[:comment] = params[:comment]
          ctx[:user] = params[:current_user]
          ctx[:commentable] = Product.find(ctx[:comment][:product_id])
          ctx[:rate] = RateCommentSetter.call(ctx[:user], ctx[:commentable])
        end

        def persist_rate(ctx, comment:, **)
          if ctx[:rate]
            ctx[:rate].update(value: comment[:rate_value]) unless comment[:rate_value].empty?
          elsif !comment[:rate_value].empty?
            Rate.create(value: comment[:rate_value], user: ctx[:user], rateable: ctx[:commentable])
          end
          true
        end

        def persist_comment(ctx, comment:, **)
          Comment.create(description: comment[:description], user: ctx[:user],
                         commentable: ctx[:commentable])
        end
      end
    end
  end
end
