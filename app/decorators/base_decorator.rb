# frozen_string_literal: true

require 'delegate'

# Class base for decorators
class BaseDecorator < SimpleDelegator
  def initialize(base, view_context)
    super(base)
    @object = base
    @view_context = view_context
  end

  def self.decorates(name)
    define_method(name) do
      @object
    end
  end

  private

  def _h
    @view_context
  end
end
