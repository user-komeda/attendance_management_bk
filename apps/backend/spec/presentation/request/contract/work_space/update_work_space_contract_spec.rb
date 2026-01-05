# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::Contract::WorkSpace::UpdateWorkSpaceContract do
  subject(:contract) { described_class.new }

  let(:valid_params) do
    { id: SecureRandom.uuid, name: 'Updated WorkSpace', slug: 'updated-workspace' }
  end

  describe '#call' do
    it 'succeeds with valid params' do
      result = contract.call(valid_params)
      expect(result).to be_success
    end

    it 'fails when id is missing' do
      result = contract.call(valid_params.except(:id))
      expect(result).not_to be_success
      expect(result.errors.to_h).to have_key(:id)
    end

    it 'fails when id is not a UUID' do
      result = contract.call(valid_params.merge(id: 'invalid-uuid'))
      expect(result).not_to be_success
      expect(result.errors.to_h[:id]).to include('is in invalid format')
    end

    it 'succeeds when name is missing (optional)' do
      result = contract.call(valid_params.except(:name))
      expect(result).to be_success
    end

    it 'succeeds when slug is missing (optional)' do
      result = contract.call(valid_params.except(:slug))
      expect(result).to be_success
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
