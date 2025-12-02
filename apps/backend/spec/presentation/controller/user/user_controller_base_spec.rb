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
    { id: '00000000-0000-0000-0000-000000000001', first_name: 'Jiro', last_name: 'Suzuki',
      email: 'jiro.suzuki@example.com' }
  end

  describe '#build_request' do
    context 'with valid CreateUserRequest class' do
      subject(:req) { controller.send(:build_request, valid_create_params, create_user_request_klass) }

      it 'returns CreateUserRequest instance' do
        expect(req).to be_a(create_user_request_klass)
      end

      it 'sets first_name' do
        expect(req.first_name).to eq('Taro')
      end

      it 'sets last_name' do
        expect(req.last_name).to eq('Yamada')
      end

      it 'sets email' do
        expect(req.email).to eq('taro.yamada@example.com')
      end
    end

    context 'with invalid class (not a UserBaseRequest subclass)' do
      it 'raises ArgumentError' do
        dummy_class = Class.new

        expect do
          controller.send(:build_request, {}, dummy_class)
        end.to raise_error(ArgumentError, /is not a valid User request class/)
      end
    end

    context 'with invalid params' do
      it 'raises BadRequestException for empty params' do
        expect do
          controller.send(:build_request, {}, create_user_request_klass)
        end.to raise_error(Presentation::Exception::BadRequestException)
      end
    end
  end

  describe '#invoke_use_case' do
    context 'when calling use case' do
      let(:mock_use_case) { instance_spy(Application::UseCase::User::GetAllUserUseCase) }
      let(:dtos) do
        [
          instance_double(Application::Dto::User::UserDto, id: '1', first_name: 'Taro'),
          instance_double(Application::Dto::User::UserDto, id: '2', first_name: 'Hanako')
        ]
      end

      before do
        allow(controller).to receive(:resolve)
          .with('application.use_case.user.get_all_user_use_case')
          .and_return(mock_use_case)

        allow(mock_use_case).to receive(:invoke).and_return(dtos)
      end

      it 'returns an array' do
        result = controller.send(:invoke_use_case, :get_all)
        expect(result).to be_a(Array)
      end

      it 'returns two elements' do
        result = controller.send(:invoke_use_case, :get_all)
        expect(result.size).to eq(2)
      end

      it 'returns first id' do
        result = controller.send(:invoke_use_case, :get_all)
        expect(result.first.id).to eq('1')
      end

      it 'returns last id' do
        result = controller.send(:invoke_use_case, :get_all)
        expect(result.last.id).to eq('2')
      end
    end
  end

  describe 'constants' do
    it 'has USER_USE_CASE frozen' do
      expect(described_class::USER_USE_CASE).to be_frozen
    end

    it 'has USER_USE_CASE equal to constant value' do
      expect(described_class::USER_USE_CASE).to eq(Constant::ContainerKey::ApplicationKey::USER_USE_CASE)
    end

    it 'has RESPONSE frozen' do
      expect(described_class::RESPONSE).to be_frozen
    end

    it 'has RESPONSE set to UserResponse' do
      expect(described_class::RESPONSE).to eq(Presentation::Response::User::UserResponse)
    end

    it 'has BASE_REQUEST frozen' do
      expect(described_class::BASE_REQUEST).to be_frozen
    end

    it 'has BASE_REQUEST set to UserBaseRequest' do
      expect(described_class::BASE_REQUEST).to eq(Presentation::Request::User::UserBaseRequest)
    end

    it 'has CREATE_REQUEST frozen' do
      expect(described_class::CREATE_REQUEST).to be_frozen
    end

    it 'has CREATE_REQUEST set to CreateUserRequest' do
      expect(described_class::CREATE_REQUEST).to eq(Presentation::Request::User::CreateUserRequest)
    end

    it 'has UPDATE_REQUEST frozen' do
      expect(described_class::UPDATE_REQUEST).to be_frozen
    end

    it 'has UPDATE_REQUEST set to UpdateUserRequest' do
      expect(described_class::UPDATE_REQUEST).to eq(Presentation::Request::User::UpdateUserRequest)
    end
  end
end
