ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/mock"
require "minitest/pride"
require "mocha/mini_test"

::Dir.glob(::Rails.root.join("test/helpers/*.rb")).each do |f|
  require f
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end