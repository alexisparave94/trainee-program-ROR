# frozen_string_literal: true

module Admin
  # Class to manage Change Logs
  class ChangeLogsController < ApplicationController
    # Method to get index of change logs
    # - GET /admin/change_logs
    def index
      @logs = ChangeLog.all
      authorize ChangeLog
    end
  end
end
