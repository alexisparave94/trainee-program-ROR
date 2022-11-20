# frozen_string_literal: true

module Admins
  # Service object to get edit product form
  class EditProductFormGetter < ApplicationService
    def initialize(params)
      @params = params
      super()
    end

    def call
      Forms::EditProductForm.new(@params)
    end
  end
end
