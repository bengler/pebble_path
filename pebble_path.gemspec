# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pebble_path/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Katrina Owen"]
  gem.email         = ["katrina.owen@gmail.com"]
  gem.description   = %q{Provide pebble-compliant paths for ActiveRecord models.}
  gem.summary       = %q{Provides searchable, parseable pebble-compliant UID paths, e.g. (such as a.b.*) for Active Record models.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pebble_path"
  gem.require_paths = ["lib"]
  gem.version       = PebblePath::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_dependency 'pebbles-uid', '>=0.0.5'
end
