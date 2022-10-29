class Admin::ChangeLogsController < ApplicationController
  def index
    @logs = ChangeLog.all
    authorize ChangeLog
  end
end
