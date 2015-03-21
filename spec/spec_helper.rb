require "simplecov"

# Only use CodeClimate when being run in CI
if ENV["CI"]
  require "codeclimate-test-reporter"
  require "coveralls"
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    Coveralls::SimpleCov::Formatter,
    CodeClimate::TestReporter::Formatter
  ]
end

SimpleCov.start do
  add_filter "spec"
end

require "powerapi"

require "savon/mock/spec_helper"

require 'webmock/rspec'
WebMock.disable_net_connect!(:allow => [/localhost/, /codeclimate.com/, /coveralls.io/])
