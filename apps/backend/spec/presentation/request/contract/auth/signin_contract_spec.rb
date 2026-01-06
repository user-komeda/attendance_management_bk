# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::Contract::Auth::SigninContract do
  subject(:contract) { described_class.new }

  def valid_params
    { email: 'taro@example.com', password: 'secret' }
  end

  describe '#call' do
    it 'succeeds with valid params' do
      expect(contract.call(valid_params).errors.to_h).to be_empty
    end

    it 'fails when fields are missing' do
      expect(contract.call({}).errors.to_h).to eq({ email: ['is missing'], password: ['is missing'] })
    end

    it 'fails when fields are blank' do
      expect(contract.call({ email: '', password: '' }).errors.to_h)
        .to eq({ email: ['must be filled'], password: ['must be filled'] })
    end

    it 'fails when email format is invalid' do
      expect(contract.call({ email: 'not-an-email', password: 'x' }).errors.to_h)
        .to eq({ email: ['is in invalid format'] })
    end
  end
end
