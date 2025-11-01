# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::Dto::User::UserDto do
  def build_user(id:, first_name:, last_name:, email:)
    entity = ::Domain::Entity::User::UserEntity.build(first_name: first_name, last_name: last_name, email: email)
    entity.id = ::Domain::ValueObject::IdentityId.build(id)
    entity
  end

  describe '.build' do
    it 'maps fields from entity' do
      user = build_user(id: 42, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')

      dto = described_class.build(user)

      expect(dto).to be_a(::Application::Dto::User::UserDto)
      expect(dto.id).to eq(42)
      expect(dto.first_name).to eq('Taro')
      expect(dto.last_name).to eq('Yamada')
      expect(dto.email).to eq('taro@example.com')
    end
  end

  describe '.build_from_array' do
    it 'returns empty array when input is empty' do
      result = described_class.build_from_array([])
      expect(result).to be_a(Array)
      expect(result).to be_empty
    end

    it 'maps each entity' do
      u1 = build_user(id: 1, first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')
      u2 = build_user(id: 2, first_name: 'Jiro', last_name: 'Sato', email: 'jiro@example.com')

      result = described_class.build_from_array([u1, u2])

      expect(result.size).to eq(2)
      expect(result.first).to be_a(::Application::Dto::User::UserDto)

      expect(result.first.id).to eq(1)
      expect(result.first.first_name).to eq('Hanako')
      expect(result.first.last_name).to eq('Suzuki')
      expect(result.first.email).to eq('hanako@example.com')

      expect(result.last.id).to eq(2)
      expect(result.last.first_name).to eq('Jiro')
      expect(result.last.last_name).to eq('Sato')
      expect(result.last.email).to eq('jiro@example.com')
    end
  end
end
