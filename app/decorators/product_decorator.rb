# frozen_string_literal: true

# Class for decorators of products
class ProductDecorator < BaseDecorator
  decorates :order

  def average_rate(rates)
    rates.reduce(0) { |acc, rate| acc + rate.value } / rates.size
  end
end
