# frozen_string_literal: true

module Admins
  # Service object to soft delete a user
  class UserSoftDeleter < ApplicationService
    def initialize(user_id)
      @user = User.find(user_id)
      super()
    end

    def call
      raise(NotValidEntryRecord, 'Imposible soft deleted user') if @user.admin?

      soft_delete_user
      @user
    end

    private

    def soft_delete_user
      @user.discard
    end
  end
end
