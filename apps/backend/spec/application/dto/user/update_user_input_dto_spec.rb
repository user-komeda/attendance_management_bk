# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Application::Dto::User::UpdateUserInputDto do
  describe '#initialize' do
    it 'assigns attributes including id' do
      dto = described_class.new(id: 9, first_name: 'New', last_name: 'Name', email: 'new@example.com')
      expect(dto).to have_attributes(id: 9, first_name: 'New', last_name: 'Name', email: 'new@example.com')
    end
  end

  describe '#convert_to_entity' do
    subject(:entity) do
      described_class.new(id: 1, first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com').convert_to_entity
    end

    it 'returns a UserEntity' do
      expect(entity).to be_a(Domain::Entity::User::UserEntity)
    end

    it 'sets first_name' do
      expect(entity.user_name.first_name).to eq('Taro')
    end

    it 'sets last_name' do
      expect(entity.user_name.last_name).to eq('Yamada')
    end

    it 'sets email' do
      expect(entity.email.value).to eq('taro@example.com')
    end

    it 'does not set id' do
      # convert_to_entity on update DTO does not set id; id is used separately by use case
      expect(entity.id).to be_nil
    end
  end
end
