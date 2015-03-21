# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "powerapi/version"

Gem::Specification.new do |spec|
  spec.name          = "powerapi"
  spec.version       = PowerAPI::VERSION
  spec.authors       = ["Henri Watson"]
  spec.email         = ["henri@henriwatson.com"]
  spec.summary       = %q{Ruby API for PowerSchool.}
  spec.description   = %q{Library for fetching information from Pearson PowerSchool installs.}
  spec.homepage      = "http://powerapi.henriwatson.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock", "~> 1.20.0"
  spec.add_development_dependency "codeclimate-test-reporter"

  spec.add_runtime_dependency "savon", "~> 2.0"
  spec.add_runtime_dependency "httpclient", "~> 2.4.0"
  spec.add_runtime_dependency "json", "~> 1.8.1"
end
