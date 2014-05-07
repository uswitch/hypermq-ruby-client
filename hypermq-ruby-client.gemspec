Gem::Specification.new do |s|
  s.name          = 'hypermq-ruby-client'
  s.version       = '0.0.1'
  s.date          = '2014-05-07'
  s.summary       = "Ruby client for hypermq restful message queue"
  s.description   = "Provides a simple interface to hypermq"
  s.authors       = ["Russell Dunphy"]
  s.email         = ['rssll@rsslldnphy.com']
  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.homepage      = 'http://github.com/uswitch/hypermq-ruby-client'
  s.license       = 'MIT'

  s.add_dependency "id"
  s.add_dependency "faraday"
  s.add_dependency "yajl-ruby"

  s.add_development_dependency "rspec"
  s.add_development_dependency "webmock"
  s.add_development_dependency "mocha"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"

end

