# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Users
          # Class to manage operation of create a product
          class Restore < Trailblazer::Operation
            step Model(User, :find_by)
            step :handle_error
            pass :restore_user

            def handle_error(_ctx, model:, **)
              raise(NotValidEntryRecord, 'User is not discarted') unless model.discarded?

              true
            end

            def restore_user(_ctx, model:, **)
              model.undiscard
            end
          end
        end
      end
    end
  end
end
