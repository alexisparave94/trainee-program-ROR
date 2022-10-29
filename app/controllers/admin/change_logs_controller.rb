class Admin::ChangeLogsController < ApplicationController
  def index
    @logs = ChangeLog.all
  end
end
