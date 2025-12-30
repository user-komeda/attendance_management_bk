# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::Auth::SigninInputDto do
  let(:params) do
    {
      email: 'test@example.com',
      password: 'Password123!'
    }
  end

  describe '#initialize' do
    subject(:dto) { described_class.new(params) }

    it 'assigns email' do
      expect(dto.email).to eq('test@example.com')
    end

    it 'assigns password' do
      expect(dto.password).to eq('Password123!')
    end
  end

  describe '#convert_to_auth_user_entity' do
    subject(:auth_entity) { described_class.new(params).convert_to_auth_user_entity }

    it 'returns an AuthUserEntity' do
      expect(auth_entity).to be_a(Domain::Entity::Auth::AuthUserEntity)
    end

    it 'sets email on entity' do
      expect(auth_entity.email.value).to eq('test@example.com')
    end

    it 'builds password_digest value object' do
      expect(auth_entity.password_digest).to be_a(Domain::ValueObject::AuthUser::PasswordDigest)
    end
  end
end
