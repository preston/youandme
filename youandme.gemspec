# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'youandme/version'

Gem::Specification.new do |spec|
  spec.name          = 'youandme'
  spec.version       = YouAndMe::VERSION
  spec.authors       = ['Preston Lee']
  spec.description  = 'An unofficial ruby library for quickly parsing 23andme raw data files into a plain Ruby structures for quick processing and analysis.'
  spec.email        = ['preston.lee@prestonlee.com']
  spec.summary      = 'Data comparison and analysis tools for 23andme raw data files.'
  spec.homepage      = 'http://github.com/preston/youandme'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'getopt'
  # spec.add_runtime_dependency 'rpeg-multimarkdown'
  # spec.add_runtime_dependency 'libxslt-ruby'

  # spec.add_development_dependency 'shoulda'
  # spec.add_development_dependency 'bundler'
  # spec.add_development_dependency 'rcov'
end
