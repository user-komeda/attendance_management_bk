# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Entity::Auth::AuthUserEntity do
  let(:bcrypt_hash) { '$2a$12$abcdefghijklmnopqrstuvABCDEFGHIJKLMNOPQRSTUVwx/yz1234567890abcd' }

  # rubocop:disable RSpec/ExampleLength
  it 'wraps values in to_domain' do
    t = Time.now
    infra = described_class.new(
      id: 'auth-1',
      user_id: 'user-1',
      email: 'hanako@example.com',
      provider: 'password',
      password_digest: bcrypt_hash,
      last_login_at: t,
      is_active: true
    )

    domain = infra.to_domain
    expect(domain).to satisfy do |d|
      d.is_a?(Domain::Entity::Auth::AuthUserEntity) &&
        d.id.value == 'auth-1' &&
        d.user_id == 'user-1' &&
        d.email.value == 'hanako@example.com' &&
        d.password_digest.value == bcrypt_hash &&
        d.provider == 'password' &&
        d.is_active == true &&
        d.last_login_at == t
    end
  end
  # rubocop:enable RSpec/ExampleLength

  # rubocop:disable RSpec/ExampleLength
  it 'builds domain entity from struct' do
    t = Time.now
    src = Struct.new(:id, :user_id, :email, :provider, :password_digest, :last_login_at, :is_active)
                .new('auth-2', 'user-2', 'ken@example.com', 'google', bcrypt_hash, t, false)

    domain = described_class.struct_to_domain(src)
    expect(domain).to satisfy do |d|
      d.is_a?(Domain::Entity::Auth::AuthUserEntity) &&
        d.id.value == 'auth-2' &&
        d.user_id == 'user-2' &&
        d.email.value == 'ken@example.com' &&
        d.password_digest.value == bcrypt_hash &&
        d.provider == 'google' &&
        d.is_active == false &&
        d.last_login_at == t
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
