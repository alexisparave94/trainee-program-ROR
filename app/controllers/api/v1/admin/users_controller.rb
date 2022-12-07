# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Class to manage user accounts
      class UsersController < ApiController
        before_action :authorize_request
        before_action :authorize_action

        # Method to create a new user
        # - POST /api/v1/admin/users
        def create
          @user = Admins::SupportUserCreator.call(user_params)
          render json: json_api_format(UserRepresenter.new(@user), 'user'), status: :created
        end

        # Method to soft delete a user
        # - PATCH /api/v1/admin/users/soft_delete/:id
        def discard
          @user = Admins::UserSoftDeleter.call(params[:id])
          render json: json_api_format(UserRepresenter.new(@user), 'user'), status: :ok
        end

        # Method to restore a user
        # - PATCH /api/v1/admin/users/restore/:id
        def restore
          @user = Admins::UserRestorer.call(params[:id])
          render json: json_api_format(UserRepresenter.new(@user), 'user'), status: :ok
        end

        private

        # Method to set strong params for user form
        def user_params
          params.require(:forms_user_form).permit(:first_name, :last_name, :email, :personal_email)
        end

        # Method to authorize actions
        def authorize_action
          authorize User
        end
      end
    end
  end
end
