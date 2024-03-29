require 'bundler/setup'

require 'simplecov'
SimpleCov.start

require 'rspec'
require 'rack/test'
require 'webmock/rspec'
require 'omniauth-medpass'

RSpec.configure do |config|
  config.include WebMock::API
  config.include Rack::Test::Methods
end