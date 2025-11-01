# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe ::Infrastructure::Entity::User::UserEntity do
  def build_domain_user(id: nil, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = id.nil? ? nil : ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  it 'wraps values in to_domain' do
    infra = described_class.new(id: 'abc', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

    domain = infra.to_domain

    expect(domain).to be_a(::Domain::Entity::User::UserEntity)
    expect(domain.id.value).to eq('abc')
    expect(domain.user_name.first_name).to eq('Hanako')
    expect(domain.user_name.last_name).to eq('Suzuki')
    expect(domain.email.value).to eq('hanako@example.com')
  end

  it 'builds domain entity from struct' do
    src = Struct.new(:id, :first_name, :last_name, :email).new('u-1', 'Ken', 'Tanaka', 'ken@example.com')

    domain = described_class.struct_to_domain(src)

    expect(domain).to be_a(::Domain::Entity::User::UserEntity)
    expect(domain.id.value).to eq('u-1')
    expect(domain.user_name.first_name).to eq('Ken')
    expect(domain.user_name.last_name).to eq('Tanaka')
    expect(domain.email.value).to eq('ken@example.com')
  end

  it 'generates uuid when id is nil on build from domain' do
    fixed_uuid = '00000000-0000-0000-0000-000000000001'
    domain = build_domain_user(id: nil, first_name: 'A', last_name: 'B', email: 'a@example.com')

    allow(SecureRandom).to receive(:uuid).and_return(fixed_uuid)
    infra = described_class.build_from_domain_entity(domain)
    expect(infra.id).to eq(fixed_uuid)
    expect(infra.first_name).to eq('A')
    expect(infra.last_name).to eq('B')
    expect(infra.email).to eq('a@example.com')
  end

  it 'uses existing id when present on build from domain' do
    domain = build_domain_user(id: '9', first_name: 'A', last_name: 'B', email: 'a@example.com')

    infra = described_class.build_from_domain_entity(domain)

    expect(infra.id).to eq('9')
    expect(infra.first_name).to eq('A')
    expect(infra.last_name).to eq('B')
    expect(infra.email).to eq('a@example.com')
  end
end