# frozen_string_literal: true

module Admin
  class ChangeLogsController < ApplicationController
    # GET /admin/change_logs
    def index
      @logs = ChangeLog.all
      authorize ChangeLog
    end
  end
end
