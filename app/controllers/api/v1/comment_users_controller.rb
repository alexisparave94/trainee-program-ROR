# frozen_string_literal: true

module Api
  module V1
    # Class to manage comments of a user for another user
    class CommentUsersController < ApiController
      before_action :authorize_request
      before_action :authorize_action

      # Method to add a new comment
      # - POST /api/v1/comment_user_forms
      def create
        @comment = Customer::Comments::CommentUserCreator.call(current_user, comment_user_form_params)
        render json: json_api_format(CommentRepresenter.new(@comment), 'comment'), status: :ok
      end

      private

      # Method to set strong paramas for order line form
      def comment_user_form_params
        params.require(:forms_comment_user_form).permit(:description, :user_id)
      end

      def authorize_action
        authorize Comment
      end
    end
  end
end
