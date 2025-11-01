# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Response::User::UserResponse do
  def build_user_dto(id:, first_name:, last_name:, email:)
    Application::Dto::User::UserDto.build(::Domain::Entity::User::UserEntity.build_with_id(id: id,
                                                                                           first_name: first_name,
                                                                                           last_name: last_name,
                                                                                           email: email))
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
    it 'builds single response hash' do
      res = described_class.build(params)

      expect(res).to be_a(Hash)
      expect(res[:id]).to eq('00000000-0000-0000-0000-000000000001')
      expect(res[:first_name]).to eq('Taro')
      expect(res[:last_name]).to eq('Yamada')
      expect(res[:email]).to eq('taro.yamada@example.com')
    end
  end

  describe '.build_from_array' do
    it 'builds array response' do
      res = described_class.build_from_array(array_params)

      # 驟榊・縺ｧ縺ゅｋ縺薙→繧堤｢ｺ隱・      expect(res).to be_a(Array)
      expect(res.size).to eq(2)

      # 蜷・ｦ∫ｴ縺粂ash縺ｧ縺ゅｋ縺薙→繧堤｢ｺ隱・      expect(res.first).to be_a(Hash)
      expect(res.last).to be_a(Hash)

      # 1逡ｪ逶ｮ縺ｮ隕∫ｴ繧呈､懆ｨｼ
      expect(res.first[:id]).to eq('00000000-0000-0000-0000-000000000001')
      expect(res.first[:first_name]).to eq('Taro')
      expect(res.first[:last_name]).to eq('Yamada')
      expect(res.first[:email]).to eq('taro.yamada@example.com')

      # 2逡ｪ逶ｮ縺ｮ隕∫ｴ繧呈､懆ｨｼ
      expect(res.last[:id]).to eq('00000000-0000-0000-0000-000000000002')
      expect(res.last[:first_name]).to eq('taichi')
      expect(res.last[:last_name]).to eq('yosida')
      expect(res.last[:email]).to eq('taichi.yosida@example.com')
    end

    it 'returns empty array when given empty array' do
      res = described_class.build_from_array([])

      expect(res).to be_a(Array)
      expect(res).to be_empty
    end
  end

  describe '#to_h' do
    it 'returns hash representation' do
      response = described_class.new(
        id: '123',
        first_name: 'Taro',
        last_name: 'Yamada',
        email: 'taro@example.com'
      )

      result = response.to_h

      expect(result).to eq({
                             id: '123',
                             first_name: 'Taro',
                             last_name: 'Yamada',
                             email: 'taro@example.com'
                           })
    end
  end
end