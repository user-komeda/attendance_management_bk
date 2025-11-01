# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Application::Dto::User::CreateUserInputDto do
  describe '#initialize' do
    it 'assigns attributes' do
      dto = described_class.new(first_name: 'Ken', last_name: 'Tanaka', email: 'ken@example.com')

      expect(dto.first_name).to eq('Ken')
      expect(dto.last_name).to eq('Tanaka')
      expect(dto.email).to eq('ken@example.com')
    end
  end

  describe '#convert_to_entity' do
    it 'builds domain entity' do
      dto = described_class.new(first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com')

      entity = dto.convert_to_entity

      expect(entity).to be_a(::Domain::Entity::User::UserEntity)
      expect(entity.user_name.first_name).to eq('Hanako')
      expect(entity.user_name.last_name).to eq('Suzuki')
      expect(entity.email.value).to eq('hanako@example.com')
      # Create should not set id here
      expect(entity.id).to be_nil
    end
  end
end
