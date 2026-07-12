# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::Contract::ContentApi::CreateContentApiContract do
  subject(:contract) { described_class.new }

  let(:valid_params) do
    {
      name: 'Articles',
      endpoint: 'articles',
      api_type: 'list'
    }
  end

  describe '#call' do
    it 'succeeds with valid params' do
      result = contract.call(valid_params)
      expect(result).to be_success
    end

    it 'succeeds with api_type object' do
      result = contract.call(valid_params.merge(api_type: 'object'))
      expect(result).to be_success
    end

    it 'fails when endpoint format is invalid' do
      result = contract.call(valid_params.merge(endpoint: 'INVALID ENDPOINT!'))
      aggregate_failures do
        expect(result).not_to be_success
        expect(result.errors.to_h).to have_key(:endpoint)
      end
    end

    it 'fails when endpoint is too short' do
      result = contract.call(valid_params.merge(endpoint: 'ab'))
      aggregate_failures do
        expect(result).not_to be_success
        expect(result.errors.to_h).to have_key(:endpoint)
      end
    end

    it 'fails when api_type is invalid' do
      result = contract.call(valid_params.merge(api_type: 'invalid'))
      aggregate_failures do
        expect(result).not_to be_success
        expect(result.errors.to_h).to have_key(:api_type)
      end
    end
  end
end
