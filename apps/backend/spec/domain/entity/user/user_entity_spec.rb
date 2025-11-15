# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Domain::Entity::User::UserEntity do
  def build_entity(first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    described_class.build(first_name: first_name, last_name: last_name, email: email)
  end

  it 'creates value objects and nil id on build' do
    entity = build_entity(first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

    expect(entity).to be_a(::Domain::Entity::User::UserEntity)
    expect(entity.id).to be_nil

    expect(entity.user_name).to be_a(::Domain::ValueObject::User::UserName)
    expect(entity.user_name.first_name).to eq('Hanako')
    expect(entity.user_name.last_name).to eq('Suzuki')

    expect(entity.email).to be_a(::Domain::ValueObject::User::UserEmail)
    expect(entity.email.value).to eq('hanako@example.com')
  end

  it 'updates only provided fields when changed' do
    entity = build_entity(first_name: 'Old', last_name: 'Name', email: 'old@example.com')

    # Update first name only
    entity.change(first_name: 'New', last_name: nil, email: nil)

    expect(entity.user_name.first_name).to eq('New')
    expect(entity.user_name.last_name).to eq('Name')
    expect(entity.email.value).to eq('old@example.com')

    # Update email only
    entity.change(first_name: nil, last_name: nil, email: 'new@example.com')

    expect(entity.user_name.first_name).to eq('New')
    expect(entity.user_name.last_name).to eq('Name')
    expect(entity.email.value).to eq('new@example.com')
  end

  it 'does nothing when all change params are nil or empty' do
    entity = build_entity(first_name: 'A', last_name: 'B', email: 'a@example.com')

    # All nil
    entity.change(first_name: nil, last_name: nil, email: nil)
    expect(entity.user_name.first_name).to eq('A')
    expect(entity.user_name.last_name).to eq('B')
    expect(entity.email.value).to eq('a@example.com')

    # All empty string
    entity.change(first_name: '', last_name: '', email: '')
    expect(entity.user_name.first_name).to eq('A')
    expect(entity.user_name.last_name).to eq('B')
    expect(entity.email.value).to eq('a@example.com')
  end

  describe '.build_with_id' do
    it 'wraps values into value objects' do
      entity = described_class.build_with_id(id: '10', first_name: 'Ken', last_name: 'Tanaka', email: 'ken@example.com')

      expect(entity).to be_a(::Domain::Entity::User::UserEntity)

      expect(entity.id).to be_a(::Domain::ValueObject::IdentityId)
      expect(entity.id.value).to eq('10')

      expect(entity.user_name).to be_a(::Domain::ValueObject::User::UserName)
      expect(entity.user_name.first_name).to eq('Ken')
      expect(entity.user_name.last_name).to eq('Tanaka')

      expect(entity.email).to be_a(::Domain::ValueObject::User::UserEmail)
      expect(entity.email.value).to eq('ken@example.com')
    end
  end
end
