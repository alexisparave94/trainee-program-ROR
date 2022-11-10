# frozen_string_literal: true

module Admin
  # Class to manage Change Logs
  class ChangeLogsController < ApplicationController
    # Method to get index of change logs
    # - GET /admin/change_logs
    def index
      authorize ChangeLog
      @logs = ChangeLog.all
    end
  end
end
