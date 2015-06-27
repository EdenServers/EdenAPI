require 'simplecov'
require 'coveralls'
Coveralls.wear!('rails')

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
#SimpleCov.minimum_coverage 95
SimpleCov.start 'rails' do
  add_group 'API Controllers' , 'app/controllers/api'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
