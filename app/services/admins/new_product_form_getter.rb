# frozen_string_literal: true

module Admins
  # Service object to get new product form
  class NewProductFormGetter < ApplicationService
    def call
      Forms::NewProductForm.new
    end
  end
end
