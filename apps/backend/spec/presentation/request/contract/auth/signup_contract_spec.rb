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
    # rubocop:disable RSpec/MultipleExpectations
    it 'succeeds with valid params' do
      result = contract.call(valid_params)
      expect(result).to be_success
      expect(result.errors.to_h).to eq({})
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
    it 'fails when fields are missing' do
      result = contract.call({})
      expect(result).not_to be_success
      expect(result.errors.to_h).to eq({
                                         email: ['is missing'],
                                         password: ['is missing'],
                                         first_name: ['is missing'],
                                         last_name: ['is missing']
                                       })
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

    # rubocop:disable RSpec/MultipleExpectations, RSpec/ExampleLength
    it 'fails when fields are blank' do
      result = contract.call({ email: '', password: '', first_name: '', last_name: '' })
      expect(result).not_to be_success
      expect(result.errors.to_h).to eq({
                                         email: ['must be filled'],
                                         password: ['must be filled'],
                                         first_name: ['must be filled'],
                                         last_name: ['must be filled']
                                       })
    end
    # rubocop:enable RSpec/MultipleExpectations, RSpec/ExampleLength

    # rubocop:disable RSpec/MultipleExpectations
    it 'fails when email format is invalid' do
      result = contract.call({ email: 'not-an-email', password: 'x', first_name: 'A', last_name: 'B' })
      expect(result).not_to be_success
      expect(result.errors.to_h).to eq({ email: ['is in invalid format'] })
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
