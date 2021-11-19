# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maxminddb/version'

Gem::Specification.new do |spec|
  spec.name          = "maxminddb"
  spec.version       = MaxMindDB::VERSION
  spec.authors       = ["yhirose"]
  spec.email         = ["yuji.hirose.bug@gmail.com"]
  spec.summary       = %q{MaxMind DB binary file reader.}
  spec.description   = %q{Pure Ruby MaxMind DB (GeoIP2) binary file reader.}
  spec.homepage      = "https://github.com/yhirose/maxminddb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
end
