# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Users
          # Class to manage operation of create a product
          class Create < Trailblazer::Operation
            step Model(User, :new)
            step Contract::Build(constant: Contracts::Users::Create)
            step Contract::Validate(key: :forms_user_form)
            fail :handle_error
            step :persist_user
            step :notify_new_user

            def handle_error(ctx, **)
              raise(NotValidEntryRecord, ctx['contract.default'].errors.messages)
            end

            def persist_user(ctx, user_params:, **)
              ctx[:user] = User.new(user_params.except('personal_email'))
              ctx[:user].role = 'support'
              ctx[:user].password = generate_random_password(ctx)
              ctx[:user].save
            end

            def notify_new_user(ctx, user:, user_params:, **)
              UserMailer.new_support_user(user, ctx[:password], user_params[:personal_email]).deliver
            end

            private

            def generate_random_password(ctx)
              ctx[:password] = Faker::Internet.password(min_length: 8, max_length: 10, mix_case: true)
            end
          end
        end
      end
    end
  end
end
