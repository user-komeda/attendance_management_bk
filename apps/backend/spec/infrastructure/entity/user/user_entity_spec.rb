# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'

RSpec.describe Infrastructure::Entity::User::UserEntity do
  def build_domain_user(first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    Domain::Entity::User::UserEntity.build(
      first_name: first_name,
      last_name: last_name,
      email: email
    )
  end

  def build_domain_user_id(id:, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email
    )
  end

  def expect_domain_entity(domain, id:, first_name:, last_name:, email:)
    expect(domain).to(satisfy do |d|
      d.is_a?(Domain::Entity::User::UserEntity) &&
        d.id.value == id &&
        d.user_name.first_name == first_name &&
        d.user_name.last_name == last_name &&
        d.email.value == email
    end)
  end

  it 'wraps values in to_domain' do
    infra = described_class.new(id: 'abc', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
    domain = infra.to_domain
    expect_domain_entity(domain, id: 'abc', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
  end

  it 'builds domain entity from struct' do
    src = Struct.new(:id, :first_name, :last_name, :email).new('u-1', 'Ken', 'Tanaka', 'ken@example.com')
    domain = described_class.struct_to_domain(src)
    expect_domain_entity(domain, id: 'u-1', first_name: 'Ken', last_name: 'Tanaka', email: 'ken@example.com')
  end

  it 'generates uuid when id is nil on build from domain' do
    fixed_uuid = '00000000-0000-0000-0000-000000000001'
    domain = build_domain_user(first_name: 'A', last_name: 'B', email: 'a@example.com')

    allow(SecureRandom).to receive(:uuid).and_return(fixed_uuid)
    infra = described_class.build_from_domain_entity(domain)
    expect(infra).to have_attributes(id: fixed_uuid, first_name: 'A', last_name: 'B', email: 'a@example.com')
  end

  it 'uses existing id when present on build from domain' do
    domain = build_domain_user_id(id: '9', first_name: 'A', last_name: 'B', email: 'a@example.com')

    infra = described_class.build_from_domain_entity(domain)
    expect(infra).to have_attributes(id: '9', first_name: 'A', last_name: 'B', email: 'a@example.com')
  end
end
