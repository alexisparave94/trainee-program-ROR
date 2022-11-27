# frozen_string_literal: true

# Service object to show a product
class ResourcesPaginator < ApplicationService
  include Pagy::Backend

  def initialize(resources, params)
    @resources = resources
    @params = params
    super()
  end

  def call
    paginate
  end

  private

  attr_reader :params

  def paginate
    pagy(@resources, items: params[:limit])
    # pagy = Pagy.new(count: @resources.count(:all), page: params[:page])
    # pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    # [pagy, @resources.offset(pagy.offset).limit(pagy.items)]
  end
end
