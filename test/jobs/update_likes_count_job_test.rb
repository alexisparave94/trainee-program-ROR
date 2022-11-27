# frozen_string_literal: true

require 'test_helper'

class UpdateLikesCountJobTest < ActiveJob::TestCase
  test 'sholud like a product' do
    # UpdateLikesCountJob.perform_later(product, 1)
    # pp product.reload
    # assert_equal product.likes_count, 1
  end
end
