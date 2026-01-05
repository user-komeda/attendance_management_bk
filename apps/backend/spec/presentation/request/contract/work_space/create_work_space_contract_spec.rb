# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::Contract::WorkSpace::CreateWorkSpaceContract do
  subject(:contract) { described_class.new }

  let(:valid_params) do
    { name: 'Test WorkSpace', slug: 'test-workspace' }
  end

  describe '#call' do
    it 'succeeds with valid params' do
      result = contract.call(valid_params)
      expect(result).to be_success
    end

    it 'fails when name is missing' do
      result = contract.call(valid_params.except(:name))
      expect(result).not_to be_success
      expect(result.errors.to_h).to have_key(:name)
    end

    it 'fails when slug is missing' do
      result = contract.call(valid_params.except(:slug))
      expect(result).not_to be_success
      expect(result.errors.to_h).to have_key(:slug)
    end

    it 'fails when name is blank' do
      result = contract.call(valid_params.merge(name: ''))
      expect(result).not_to be_success
      expect(result.errors.to_h[:name]).to include('must be filled')
    end

    it 'fails when slug is blank' do
      result = contract.call(valid_params.merge(slug: ''))
      expect(result).not_to be_success
      expect(result.errors.to_h[:slug]).to include('must be filled')
    end
  end
end
