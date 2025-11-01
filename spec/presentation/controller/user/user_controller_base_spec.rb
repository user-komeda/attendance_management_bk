# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Controller::User::UserControllerBase do
  let(:controller) { described_class.new }
  let(:create_user_request_klass) { Presentation::Request::User::CreateUserRequest }
  let(:update_user_request_klass) { Presentation::Request::User::UpdateUserRequest }

  def valid_create_params
    { first_name: 'Taro', last_name: 'Yamada', email: 'taro.yamada@example.com' }
  end

  def valid_update_params
    { id: '00000000-0000-0000-0000-000000000001', first_name: 'Jiro', last_name: 'Suzuki', email: 'jiro.suzuki@example.com' }
  end

  describe '#build_request' do
    context 'with valid CreateUserRequest class' do
      it 'returns CreateUserRequest instance' do
        req = controller.send(:build_request, valid_create_params, create_user_request_klass)

        expect(req).to be_a(create_user_request_klass)
        expect(req.first_name).to eq('Taro')
        expect(req.last_name).to eq('Yamada')
        expect(req.email).to eq('taro.yamada@example.com')
      end
    end

    context 'with invalid class (not a UserBaseRequest subclass)' do
      it 'raises ArgumentError' do
        dummy_class = Class.new

        expect {
          controller.send(:build_request, {}, dummy_class)
        }.to raise_error(ArgumentError, /is not a valid User request class/)
      end
    end

    context 'with invalid params' do
      it 'raises BadRequestException for empty params' do
        expect {
          controller.send(:build_request, {}, create_user_request_klass)
        }.to raise_error(Presentation::Exception::BadRequestException)
      end
    end
  end

  describe '#invoke_use_case' do
    # 莉｣陦ｨ逧・↑1縺､縺ｮ繧ｱ繝ｼ繧ｹ縺縺代ユ繧ｹ繝・
    context 'when calling use case' do
      it 'resolves container key and invokes the use case' do
        # 繝｢繝・け縺ｮ貅門ｙ
        mock_use_case = double('GetAllUserUseCase')
        stub_dto1 = double('UserDto', id: '1', first_name: 'Taro')
        stub_dto2 = double('UserDto', id: '2', first_name: 'Hanako')

        # resolve 繝｡繧ｽ繝・ラ繧偵せ繧ｿ繝門喧・亥ｮ滄圀縺ｮ繧ｭ繝ｼ蛟､繧剃ｽｿ縺・ｼ・        expected_key = 'application.use_case.user.get_all_user_use_case'
        allow(controller).to receive(:resolve)
                               .with(expected_key)
                               .and_return(mock_use_case)

        # 繝｢繝・け・喨nvoke縺悟他縺ｰ繧後ｋ縺薙→繧呈､懆ｨｼ
        expect(mock_use_case).to receive(:invoke)
                                   .and_return([stub_dto1, stub_dto2])

        # 螳溯｡・        result = controller.send(:invoke_use_case, :get_all)

        # 讀懆ｨｼ
        expect(result).to be_a(Array)
        expect(result.size).to eq(2)
        expect(result.first.id).to eq('1')
        expect(result.last.id).to eq('2')
      end
    end
  end

  describe 'constants' do
    it 'defines USER_USE_CASE as frozen hash' do
      expect(described_class::USER_USE_CASE).to be_frozen
      expect(described_class::USER_USE_CASE).to eq(Constant::ContainerKey::ApplicationKey::USER_USE_CASE)
    end

    it 'defines RESPONSE as UserResponse class' do
      expect(described_class::RESPONSE).to be_frozen
      expect(described_class::RESPONSE).to eq(Presentation::Response::User::UserResponse)
    end

    it 'defines BASE_REQUEST as UserBaseRequest class' do
      expect(described_class::BASE_REQUEST).to be_frozen
      expect(described_class::BASE_REQUEST).to eq(Presentation::Request::User::UserBaseRequest)
    end

    it 'defines CREATE_REQUEST as frozen CreateUserRequest class' do
      expect(described_class::CREATE_REQUEST).to be_frozen
      expect(described_class::CREATE_REQUEST).to eq(Presentation::Request::User::CreateUserRequest)
    end

    it 'defines UPDATE_REQUEST as frozen UpdateUserRequest class' do
      expect(described_class::UPDATE_REQUEST).to be_frozen
      expect(described_class::UPDATE_REQUEST).to eq(Presentation::Request::User::UpdateUserRequest)
    end
  end
end