# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Response::User::UserResponse do
  def build_user_dto(id:, first_name:, last_name:, email:)
    entity = Domain::Entity::User::UserEntity.build_with_id(
      id: id,
      first_name: first_name,
      last_name: last_name,
      email: email,
      session_version: 1
    )
    Application::Dto::User::UserDto.build(user_entity: entity)
  end

  def params
    build_user_dto(
      id: '00000000-0000-0000-0000-000000000001',
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro.yamada@example.com'
    )
  end

  def array_params
    [
      build_user_dto(
        id: '00000000-0000-0000-0000-000000000001',
        first_name: 'Taro',
        last_name: 'Yamada',
        email: 'taro.yamada@example.com'
      ),
      build_user_dto(
        id: '00000000-0000-0000-0000-000000000002',
        first_name: 'taichi',
        last_name: 'yosida',
        email: 'taichi.yosida@example.com'
      )
    ]
  end

  describe '.build' do
    subject(:res) { described_class.build(params) }

    it 'returns a hash' do
      expect(res).to be_a(Hash)
    end

    it 'sets id' do
      expect(res[:id]).to eq('00000000-0000-0000-0000-000000000001')
    end

    it 'sets first_name' do
      expect(res[:first_name]).to eq('Taro')
    end

    it 'sets last_name' do
      expect(res[:last_name]).to eq('Yamada')
    end

    it 'sets email' do
      expect(res[:email]).to eq('taro.yamada@example.com')
    end
  end

  describe '.build_from_array' do
    subject(:res) { described_class.build_from_array(array_params) }

    it 'returns an array' do
      expect(res).to be_a(Array)
    end

    it 'has two elements' do
      expect(res.size).to eq(2)
    end

    it 'has hash elements (first)' do
      expect(res.first).to be_a(Hash)
    end

    it 'has hash elements (last)' do
      expect(res.last).to be_a(Hash)
    end

    context 'with first element' do
      it 'has id' do
        expect(res.first[:id]).to eq('00000000-0000-0000-0000-000000000001')
      end

      it 'has first_name' do
        expect(res.first[:first_name]).to eq('Taro')
      end

      it 'has last_name' do
        expect(res.first[:last_name]).to eq('Yamada')
      end

      it 'has email' do
        expect(res.first[:email]).to eq('taro.yamada@example.com')
      end
    end

    context 'with last element' do
      it 'has id' do
        expect(res.last[:id]).to eq('00000000-0000-0000-0000-000000000002')
      end

      it 'has first_name' do
        expect(res.last[:first_name]).to eq('taichi')
      end

      it 'has last_name' do
        expect(res.last[:last_name]).to eq('yosida')
      end

      it 'has email' do
        expect(res.last[:email]).to eq('taichi.yosida@example.com')
      end
    end

    describe 'when given empty array' do
      subject(:empty_res) { described_class.build_from_array([]) }

      it 'returns an array' do
        expect(empty_res).to be_a(Array)
      end

      it 'returns empty' do
        expect(empty_res).to be_empty
      end
    end
  end

  describe '#to_h' do
    subject(:result) { response.to_h }

    let(:response) do
      described_class.new(id: '123', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com')
    end

    it 'returns hash representation' do
      expect(result).to eq({ id: '123', first_name: 'Taro', last_name: 'Yamada', email: 'taro@example.com' })
    end
  end
end
