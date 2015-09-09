# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record_record/version'

Gem::Specification.new do |spec|
  spec.name          = "active_record_record"
  spec.version       = ActiveRecordRecord::VERSION
  spec.authors       = ["Mavenlink, Inc.", "Andrew Cantino", "Jack Wilson"]
  spec.email         = ["opensource@mavenlink.com"]

  spec.summary       = %q{ActiveRecord Record is a Railtie that instruments ActiveRecord and records SQL queries, model instantiations, and view renders.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/mavenlink/active_record_record"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "railties", ">= 3.2.0"
  spec.add_runtime_dependency "activerecord", ">= 3.2.0"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
