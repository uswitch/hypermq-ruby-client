require 'rspec'
require 'simplecov'
require 'webmock/rspec'

SimpleCov.start do
  add_filter 'spec'
end

require 'hypermq/client'

RSpec.configure do |c|
  c.order = :rand
  c.mock_with :mocha
end
