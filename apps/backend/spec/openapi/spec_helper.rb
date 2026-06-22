# frozen_string_literal: true

require 'rack/test'
require 'openapi_first'

require_relative '../spec_helper'
require_relative 'support/openapi_contract_helper'
require_relative 'support/openapi_optional_coverage'

ENV['RACK_ENV'] = 'test'

OpenapiFirst::Test.setup do |test|
  test.register(File.join(ROOT_DIR, 'openApi', 'openapi.yaml'))
  test.skip_response_coverage do |response|
    %w[default 401].include?(response.status)
  end
end

OPENAPI_APP = OpenapiFirst::Test.app(APP, validate_request_before_handling: true)

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :openapi
  config.include OpenapiContractHelper, type: :openapi
  config.include OpenapiOptionalCoverage, type: :openapi

  config.after(:suite) do
    OpenapiOptionalCoverage.report!
  end
end
