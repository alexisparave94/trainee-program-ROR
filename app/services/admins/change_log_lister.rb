# frozen_string_literal: true

module Admins
  # Service object to delete a comment
  class ChangeLogLister < ApplicationService
    def call
      list_change_log
    end

    def list_change_log
      ChangeLog.all.includes(:user)
    end
  end
end
