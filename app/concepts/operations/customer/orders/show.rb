# frozen_string_literal: true

module Operations
  module Customer
    module Orders
      # Class to manage operation of show a product
      class Show < Trailblazer::Operation
        step Model(Comment, :new)
        step Contract::Build(constant: Contracts::Comments::CommentOrder)
        step :set_information

        def set_information(ctx, params:, current_user:, **)
          @information = InformationProductShow.new(params[:id], current_user)
          ctx[:information] = @information
        end

        # Class to storage infotmation of view
        class InformationProductShow
          attr_accessor :user, :commentable, :rate

          def initialize(id, user = nil)
            @user = user
            @commentable = Order.find(id)
            @rate = RateCommentSetter.call(@user, @commentable)
          end
        end
      end
    end
  end
end
