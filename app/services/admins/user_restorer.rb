# frozen_string_literal: true

module Admins
  # Service object to restore a user
  class UserRestorer < ApplicationService
    def initialize(user_id)
      @user = User.find(user_id)
      super()
    end

    def call
      raise(NotValidEntryRecord, 'User is not discarted') unless @user.discarded?

      restore_user
      @user
    end

    private

    def restore_user
      @user.undiscard
    end
  end
end
