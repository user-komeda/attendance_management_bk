# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::Dto::User::CreateUserInputDto do
  let(:params) do
    {
      first_name: 'Ken',
      last_name: 'Tanaka',
      email: 'ken@example.com'
    }
  end

  describe '#initialize' do
    subject(:dto) { described_class.new(params) }

    it 'assigns first_name' do
      expect(dto.first_name).to eq('Ken')
    end

    it 'assigns last_name' do
      expect(dto.last_name).to eq('Tanaka')
    end

    it 'assigns email' do
      expect(dto.email).to eq('ken@example.com')
    end
  end

  describe '#convert_to_entity' do
    subject(:entity) do
      described_class.new(params).convert_to_entity
    end

    let(:params) do
      {
        first_name: 'Hanako',
        last_name: 'Suzuki',
        email: 'hanako@example.com'
      }
    end

    it 'returns a UserEntity' do
      expect(entity).to be_a(::Domain::Entity::User::UserEntity)
    end

    it 'sets first_name' do
      expect(entity.user_name.first_name).to eq('Hanako')
    end

    it 'sets last_name' do
      expect(entity.user_name.last_name).to eq('Suzuki')
    end

    it 'sets email' do
      expect(entity.email.value).to eq('hanako@example.com')
    end

    it 'does not set id' do
      expect(entity.id).to be_nil
    end
  end
end
