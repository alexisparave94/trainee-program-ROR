# frozen_string_literal: true

module Operations
  module Admin
    module ChangeLogs
      # Class to manage operation of list all products
      class Index < Trailblazer::Operation
        step :set_change_logs

        def set_change_logs(ctx, **)
          ctx[:change_logs] = ChangeLog.all.includes(:user)
        end
      end
    end
  end
end
