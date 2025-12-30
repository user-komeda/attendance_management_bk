# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Presentation::Request::Auth::SigninRequest do
  let(:valid_params) do
    {
      email: 'test@example.com',
      password: 'Password123!'
    }
  end

  describe '.build' do
    context 'when params are valid' do
      subject(:request) { described_class.build(valid_params) }

      it 'returns a SigninRequest instance' do
        expect(request).to be_a(described_class)
      end

      it 'sets the email' do
        expect(request.email).to eq('test@example.com')
      end

      it 'sets the password' do
        expect(request.password).to eq('Password123!')
      end
    end

    context 'when params are invalid' do
      it 'raises BadRequestException' do
        invalid_params = { email: 'invalid', password: '' }
        expect do
          described_class.build(invalid_params)
        end.to raise_error(Presentation::Exception::BadRequestException)
      end
    end
  end

  describe '#convert_to_dto' do
    subject(:dto) { described_class.build(valid_params).convert_to_dto }

    it 'returns a SigninInputDto' do
      expect(dto).to be_a(Application::Dto::Auth::SigninInputDto)
    end

    it 'contains the correct email' do
      expect(dto.email).to eq('test@example.com')
    end

    it 'contains the correct password' do
      expect(dto.password).to eq('Password123!')
    end
  end
end
