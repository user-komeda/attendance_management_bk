# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Entity::Auth::AuthUserEntity do
  describe '.build_with_id' do
    subject(:entity) do
      described_class.build_with_id(
        id: '00000000-0000-0000-0000-000000000001',
        user_id: 'user-1',
        email: 'b@example.com',
        password: 'Abcdefg1',
        provider: 'local',
        is_active: true,
        last_login_at: Time.at(0)
      )
    end

    it 'sets id and user_id' do
      expect(entity).to satisfy do |e|
        e.id.is_a?(Domain::ValueObject::IdentityId) && e.user_id == 'user-1'
      end
    end

    it 'sets email and password_digest value objects' do
      expect(entity).to satisfy do |e|
        e.email.is_a?(Domain::ValueObject::User::UserEmail) &&
          e.password_digest.is_a?(Domain::ValueObject::AuthUser::PasswordDigest)
      end
    end

    it 'sets provider and flags' do
      expect(entity).to satisfy do |e|
        e.provider == 'local' && e.is_active == true && e.last_login_at == Time.at(0)
      end
    end
  end
end
