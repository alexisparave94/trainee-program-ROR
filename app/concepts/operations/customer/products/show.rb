# frozen_string_literal: true

module Operations
  module Customer
    module Products
      # Class to manage operation of show a product
      class Show < Trailblazer::Operation
        step Model(Comment, :new)
        step Contract::Build(constant: Contracts::Comments::CommentProduct)
        step :set_information

        def set_information(ctx, params:, **)
          @information = InformationProductShow.new(params[:id], params[:current_user])
          ctx[:information] = @information
        end

        # Class to storage infotmation of view
        class InformationProductShow
          attr_accessor :user, :commentable, :rate

          def initialize(id, user = nil)
            @user = user
            @commentable = Product.find(id)
            @rate = RateCommentSetter.call(@user, @commentable)
          end
        end
      end
    end
  end
end
