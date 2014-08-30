require "simplecov"

# Only use Coveralls when being run in CI
if ENV["CI"]
  require "coveralls"
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
end

SimpleCov.start do
  add_filter "spec"
end

require "powerapi"

require "savon/mock/spec_helper"
