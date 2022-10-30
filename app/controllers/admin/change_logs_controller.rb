class Admin::ChangeLogsController < ApplicationController
  # GET /admin/change_logs
  def index
    @logs = ChangeLog.all
    authorize ChangeLog
  end
end
