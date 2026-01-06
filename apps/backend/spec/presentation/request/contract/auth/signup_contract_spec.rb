# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::Contract::Auth::SignupContract do
  subject(:contract) { described_class.new }

  def valid_params
    {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'Secret123!'
    }
  end

  describe '#call' do
    it 'succeeds with valid params' do
      expect(contract.call(valid_params).errors.to_h).to be_empty
    end

    it 'fails when fields are missing' do
      errors = contract.call({}).errors.to_h
      expect(errors).to include(email: ['is missing'], password: ['is missing'])
    end

    it 'fails when fields are blank' do
      errors = contract.call({ email: '', password: '', first_name: '', last_name: '' }).errors.to_h
      expect(errors).to include(email: ['must be filled'], password: ['must be filled'])
    end

    it 'fails when email format is invalid' do
      expect(contract.call(valid_params.merge(email: 'bad')).errors.to_h)
        .to eq({ email: ['is in invalid format'] })
    end
  end
end
