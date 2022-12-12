# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Class to manage interactions between admin user and comments for a product or a user
      class CommentsController < ApiController
        before_action :authorize_request
        before_action :set_comment
        before_action :authorize_action

        def destroy
          # @comment = Admins::CommentDeleter.call(@comment)
          run Operations::Api::V1::Admin::Comments::Delete
          render json: @comment, status: :no_content
        end

        def approve
          # @comment = Admins::CommentApprover.call(@comment)
          run Operations::Api::V1::Admin::Comments::Approve do |ctx|
            @comment = ctx[:model]
          end
          render json: json_api_format(CommentRepresenter.new(@comment), 'comment'), status: :ok
        end

        private

        def set_comment
          @comment = Comment.find(params[:id])
        end

        def authorize_action
          authorize @comment
        end
      end
    end
  end
end
