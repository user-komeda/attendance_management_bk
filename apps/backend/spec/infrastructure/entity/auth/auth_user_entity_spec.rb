# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Infrastructure::Entity::Auth::AuthUserEntity do
  let(:bcrypt_hash) { '$2a$12$abcdefghijklmnopqrstuvABCDEFGHIJKLMNOPQRSTUVwx/yz1234567890abcd' }

  let(:now) { Time.now }
  let(:infra_attributes) do
    { id: 'auth-1', user_id: 'user-1', email: 'hanako@example.com', provider: 'password',
      password_digest: bcrypt_hash, last_login_at: now, is_active: true }
  end

  it 'wraps values in to_domain' do
    infra = described_class.new(**infra_attributes)
    expect(infra.to_domain).to be_a(Domain::Entity::Auth::AuthUserEntity)
  end

  it 'builds domain entity from struct' do
    src = Struct.new(*infra_attributes.keys).new(*infra_attributes.values)
    domain = described_class.struct_to_domain(src)
    expect(domain).to be_a(Domain::Entity::Auth::AuthUserEntity)
  end
end
