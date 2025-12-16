# frozen_string_literal: true

require_relative '../../../spec_helper'

RSpec.describe Presentation::Controller::Auth::AuthController do
  let(:controller) { described_class.new }

  def valid_params
    {
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'Password123!'
    }
  end

  describe '#signup' do
    let(:signup_request_double) do
      instance_double(Presentation::Request::Auth::SignupRequest, convert_to_dto: input_dto)
    end
    let(:input_dto) { instance_double(Application::Dto::Auth::SignupInputDto) }
    let(:use_case_result) { instance_double(Application::Dto::Auth::AuthOutputDto, id: 'auth-1', user_id: 'user-1') }

    before do
      allow(controller).to receive(:build_request)
        .with(valid_params, described_class::SIGNUP_REQUEST)
        .and_return(signup_request_double)

      allow(controller).to receive(:invoke_use_case)
        .with(:signup, input_dto)
        .and_return(use_case_result)
    end

    it 'returns auth response hash with id and user_id' do
      result = controller.signup(valid_params)
      expect(result).to eq({ id: 'auth-1', user_id: 'user-1' })
    end

    # rubocop:disable RSpec/ExampleLength
    it 'builds request with SIGNUP_REQUEST class' do
      allow(controller).to receive(:build_request)
        .with(valid_params, described_class::SIGNUP_REQUEST)
        .and_return(signup_request_double)

      # keep invoke stubs for full flow
      allow(controller).to receive(:invoke_use_case).with(:signup, input_dto).and_return(use_case_result)

      controller.signup(valid_params)
      expect(controller).to have_received(:build_request)
        .with(valid_params, described_class::SIGNUP_REQUEST)
    end
    # rubocop:enable RSpec/ExampleLength

    it 'invokes signup use case with dto converted from request' do
      allow(controller).to receive(:invoke_use_case).with(:signup, input_dto).and_return(use_case_result)
      controller.signup(valid_params)
      expect(controller).to have_received(:invoke_use_case).with(:signup, input_dto)
    end
  end
end
