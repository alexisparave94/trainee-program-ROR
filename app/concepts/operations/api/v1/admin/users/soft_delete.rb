# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Users
          # Class to manage operation of create a product
          class SoftDelete < Trailblazer::Operation
            step Model(User, :find_by)
            step :handle_error
            pass :soft_delete_user

            def handle_error(_ctx, model:, **)
              raise(NotValidEntryRecord, 'Imposible soft deleted user') if model.admin?

              true
            end

            def soft_delete_user(_ctx, model:, **)
              model.discard
            end
          end
        end
      end
    end
  end
end
