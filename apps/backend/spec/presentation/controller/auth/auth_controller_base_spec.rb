# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Controller::Auth::AuthControllerBase do
  let(:controller) { described_class.new }
  let(:signup_request_klass) { Presentation::Request::Auth::SignupRequest }

  def valid_signup_params
    {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro.yamada@example.com',
      password: 'Password123!'
    }
  end

  describe '#build_request' do
    context 'with valid SignupRequest class' do
      subject(:req) { controller.send(:build_request, valid_signup_params, signup_request_klass) }

      it 'returns SignupRequest instance' do
        expect(req).to be_a(signup_request_klass)
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

      it 'sets password' do
        expect(req.password).to eq('Password123!')
      end
    end

    context 'with invalid class (not an AuthBaseRequest subclass)' do
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
          controller.send(:build_request, {}, signup_request_klass)
        end.to raise_error(Presentation::Exception::BadRequestException)
      end
    end
  end

  describe '#invoke_use_case' do
    context 'when calling signup use case' do
      let(:mock_use_case) { instance_spy(Application::UseCase::Auth::SignupUseCase) }
      let(:expected_key) { 'application.use_case.auth.signup_use_case' }

      before do
        allow(controller).to receive(:resolve)
          .with(expected_key)
          .and_return(mock_use_case)

        allow(mock_use_case).to receive(:invoke).and_return(:ok)
      end

      it 'resolves and invokes the use case' do
        result = controller.send(:invoke_use_case, :signup, nil)
        expect(result).to eq(:ok)
      end
    end
  end

  describe 'constants' do
    it 'has AUTH_USE_CASE frozen' do
      expect(described_class::AUTH_USE_CASE).to be_frozen
    end

    it 'has AUTH_USE_CASE equal to constant value' do
      expect(described_class::AUTH_USE_CASE).to eq(Constant::ContainerKey::ApplicationKey::AUTH_USE_CASE)
    end

    it 'has AUTH_RESPONSE frozen' do
      expect(described_class::AUTH_RESPONSE).to be_frozen
    end

    it 'has AUTH_RESPONSE set to AuthResponse' do
      expect(described_class::AUTH_RESPONSE).to eq(Presentation::Response::Auth::AuthResponse)
    end

    it 'has BASE_REQUEST frozen' do
      expect(described_class::BASE_REQUEST).to be_frozen
    end

    it 'has BASE_REQUEST set to AuthBaseRequest' do
      expect(described_class::BASE_REQUEST).to eq(Presentation::Request::Auth::AuthBaseRequest)
    end

    it 'has SIGNUP_REQUEST frozen' do
      expect(described_class::SIGNUP_REQUEST).to be_frozen
    end

    it 'has SIGNUP_REQUEST set to SignupRequest' do
      expect(described_class::SIGNUP_REQUEST).to eq(Presentation::Request::Auth::SignupRequest)
    end
  end
end
