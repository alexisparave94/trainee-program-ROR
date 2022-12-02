# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/app/channels/'
  add_filter '/app/services/'
  add_filter '/app/docs/'
  add_filter '/app/decorators/'
  add_filter '/app/errors/'
  add_filter '/app/helpers/'
  add_filter '/app/policies/'
  add_filter '/app/erros/'
  add_filter '/app/representers/'
  # add_filter '/app/models/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  # add_group 'Jobs', 'app/jobs'
  # add_group 'Mailers', 'app/mailers'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    # Run tests in parallel with specified workers
    # parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end
