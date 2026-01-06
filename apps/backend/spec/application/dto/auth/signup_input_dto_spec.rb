# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::Auth::SignupInputDto do
  let(:params) do
    {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      # Password must satisfy current policy: >=8 chars, includes uppercase, lowercase, and digit
      password: 'SecretPass1'
    }
  end

  describe '#initialize' do
    subject(:dto) { described_class.new(params: params) }

    it 'assigns first_name' do
      expect(dto.first_name).to eq('Taro')
    end

    it 'assigns last_name' do
      expect(dto.last_name).to eq('Yamada')
    end

    it 'assigns email' do
      expect(dto.email).to eq('taro@example.com')
    end

    it 'assigns password' do
      expect(dto.password).to eq('SecretPass1')
    end
  end

  describe '#convert_to_user_entity' do
    subject(:entity) { described_class.new(params: params).convert_to_user_entity }

    it 'returns a UserEntity' do
      expect(entity).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'sets first_name' do
      expect(entity.user_name.first_name).to eq('Taro')
    end

    it 'sets last_name' do
      expect(entity.user_name.last_name).to eq('Yamada')
    end

    it 'sets email' do
      expect(entity.email.value).to eq('taro@example.com')
    end

    it 'does not set id' do
      expect(entity.id).to be_nil
    end
  end

  describe '#convert_to_auth_user_entity' do
    subject(:auth_entity) { described_class.new(params: params).convert_to_auth_user_entity }

    it 'returns an AuthUserEntity' do
      expect(auth_entity).to be_a(Domain::Entity::Auth::AuthUserEntity)
    end

    it 'sets email on entity' do
      expect(auth_entity.email.value).to eq('taro@example.com')
    end

    it 'builds password_digest value object' do
      expect(auth_entity.password_digest).to be_a(Domain::ValueObject::AuthUser::PasswordDigest)
    end
  end
end
