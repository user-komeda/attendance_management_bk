# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::Dto::User::UserDto do
  def build_user(id:, first_name:, last_name:, email:)
    Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email
    )
  end

  describe '.build' do
    it 'maps fields from entity' do
      user = build_user(id: '42', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
      dto = described_class.build(user)
      expect(dto).to have_attributes(id: '42', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    end
  end

  describe '.build_from_array' do
    it 'returns empty array when input is empty' do
      result = described_class.build_from_array([])
      expect(result).to eq([])
    end

    context 'with multiple entities' do
      let(:first_user) { build_user(id: '1', first_name: 'Hanako', last_name: 'Suzuki', email: 'hanako@example.com') }
      let(:second_user) { build_user(id: '2', first_name: 'Jiro', last_name: 'Sato', email: 'jiro@example.com') }
      let(:result) { described_class.build_from_array([first_user, second_user]) }

      it 'returns two results' do
        expect(result.size).to eq(2)
      end

      it 'wraps items with described_class' do
        expect(result.first).to be_a(described_class)
      end

      it 'sets first dto id' do
        expect(result.first.id).to eq('1')
      end

      it 'sets first dto first_name' do
        expect(result.first.first_name).to eq('Hanako')
      end

      it 'sets first dto last_name' do
        expect(result.first.last_name).to eq('Suzuki')
      end

      it 'sets first dto email' do
        expect(result.first.email).to eq('hanako@example.com')
      end

      it 'sets last dto id' do
        expect(result.last.id).to eq('2')
      end

      it 'sets last dto first_name' do
        expect(result.last.first_name).to eq('Jiro')
      end

      it 'sets last dto last_name' do
        expect(result.last.last_name).to eq('Sato')
      end

      it 'sets last dto email' do
        expect(result.last.email).to eq('jiro@example.com')
      end
    end
  end
end
