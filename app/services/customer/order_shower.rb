# frozen_string_literal: true

module Customer
  # Service object to show an order of a user
  class OrderShower < ApplicationService
    def initialize(params, user)
      @params = params
      @user = user
      super()
    end

    def call
      Forms::CommentOrderForm.new(@params, @user)
    end
  end
end
