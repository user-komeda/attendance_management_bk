# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Domain::Entity::User::UserEntity do
  def build_entity(first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    described_class.build(first_name: first_name, last_name: last_name, email: email)
  end

  it 'creates value objects and nil id on build' do
    entity = build_entity(first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

    expect(entity).to have_attributes(
      class: described_class,
      id: be_nil
    )
  end

  describe 'initialization' do
    let(:entity) { build_entity(first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com') }

    it 'sets the correct user name class' do
      expect(entity.user_name).to be_a(Domain::ValueObject::User::UserName)
    end

    it 'sets the correct first name' do
      expect(entity.user_name.first_name).to eq('Hanako')
    end

    it 'sets the correct last name' do
      expect(entity.user_name.last_name).to eq('Suzuki')
    end
  end

  it 'sets the correct email' do
    entity = build_entity(first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

    expect(entity.email).to have_attributes(
      class: Domain::ValueObject::User::UserEmail,
      value: 'hanako@example.com'
    )
  end

  describe '#change' do
    let(:entity) { build_entity(first_name: 'Old', last_name: 'Name', email: 'old@example.com') }

    it 'updates only first name when only first name is provided' do
      entity.change(first_name: 'New', last_name: nil, email: nil)
      expect(entity.user_name.first_name).to eq('New')
    end

    it 'keeps existing last name' do
      entity.change(first_name: 'New', last_name: nil, email: nil)
      expect(entity.user_name.last_name).to eq('Name')
    end

    it 'keeps existing email' do
      entity.change(first_name: 'New', last_name: nil, email: nil)
      expect(entity.email.value).to eq('old@example.com')
    end

    it 'updates only email when only email is provided' do
      entity.change(first_name: nil, last_name: nil, email: 'new@example.com')
      expect(entity.email.value).to eq('new@example.com')
    end

    it 'keeps existing first name when only email is updated' do
      entity.change(first_name: nil, last_name: nil, email: 'new@example.com')
      expect(entity.user_name.first_name).to eq('Old')
    end

    it 'keeps existing last name when only email is updated' do
      entity.change(first_name: nil, last_name: nil, email: 'new@example.com')
      expect(entity.user_name.last_name).to eq('Name')
    end
  end

  describe '#change with nil or empty' do
    let(:entity) { build_entity(first_name: 'A', last_name: 'B', email: 'a@example.com') }

    it 'keeps existing user name when all change params are nil' do
      entity.change(first_name: nil, last_name: nil, email: nil)
      expect(entity.user_name.first_name).to eq('A')
    end

    it 'keeps existing email when all change params are nil' do
      entity.change(first_name: nil, last_name: nil, email: nil)
      expect(entity.email.value).to eq('a@example.com')
    end

    it 'keeps existing user name when all change params are empty string' do
      entity.change(first_name: '', last_name: '', email: '')
      expect(entity.user_name.first_name).to eq('A')
    end

    it 'keeps existing email when all change params are empty string' do
      entity.change(first_name: '', last_name: '', email: '')
      expect(entity.email.value).to eq('a@example.com')
    end
  end

  describe '.build_with_id' do
    let(:built_entity) do
      described_class.build_with_id(id: '10', first_name: 'Ken', last_name: 'Tanaka',
                                    email: 'ken@example.com', session_version: 1)
    end

    it 'returns a user entity' do
      expect(built_entity).to be_a(described_class)
    end

    it 'sets the correct identity id' do
      expect(built_entity.id.value).to eq('10')
    end

    it 'sets the correct first name' do
      expect(built_entity.user_name.first_name).to eq('Ken')
    end

    it 'sets the correct last name' do
      expect(built_entity.user_name.last_name).to eq('Tanaka')
    end

    it 'sets the correct email' do
      expect(built_entity.email.value).to eq('ken@example.com')
    end
  end
end
