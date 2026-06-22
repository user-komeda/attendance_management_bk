# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::Auth::SigninUseCase do
  subject(:use_case) { described_class.new }

  before do
    if defined?(auth_repo)
      allow(use_case).to receive(:resolve).with(described_class::AUTH_REPOSITORY_KEY)
                                          .and_return(auth_repo)
    end
    if defined?(service_caller)
      allow(use_case).to receive(:resolve).with(described_class::SERVICE_KEY)
                                          .and_return(service_caller)
    end
  end

  let(:input_dto) do
    Application::Dto::Auth::SigninInputDto.new(
      params: {
        email: 'taro@example.com',
        password: 'Abcdefg1'
      }
    )
  end

  describe '#invoke' do
    context 'when credentials are valid (success path)' do
      let(:auth_user) do
        id_double = instance_double(Domain::ValueObject::IdentityId, value: '00000000-0000-0000-0000-000000000001')
        instance_double(
          Domain::Entity::Auth::AuthUserEntity,
          id: id_double,
          user_id: '00000000-0000-0000-0000-000000000001'
        )
      end
      let(:auth_repo) do
        instance_double(Domain::Repository::Auth::AuthRepository, find_by_email: auth_user)
      end
      let(:service_caller) do
        instance_double(Domain::Service::Auth::AuthService, can_login?: true)
      end

      it 'returns AuthOutputDto with id and user_id' do
        result = use_case.invoke(args: input_dto)

        expect(result).to have_attributes(
          id: '00000000-0000-0000-0000-000000000001',
          user_id: '00000000-0000-0000-0000-000000000001'
        )
      end

      it 'calls find_by_email with the given email' do
        use_case.invoke(args: input_dto)
        expect(auth_repo).to have_received(:find_by_email).with(email: input_dto.email)
      end

      it 'calls can_login? with the auth_user and password' do
        use_case.invoke(args: input_dto)
        expect(service_caller).to have_received(:can_login?).with(auth_user: auth_user, password: input_dto.password)
      end
    end

    context 'when user is not found' do
      let(:auth_repo) do
        instance_double(Domain::Repository::Auth::AuthRepository, find_by_email: nil)
      end
      let(:service_caller) do
        instance_double(Domain::Service::Auth::AuthService)
      end

      it 'raises AuthenticationFailedException' do
        expect { use_case.invoke(args: input_dto) }
          .to raise_error(Application::Exception::AuthenticationFailedException)
      end
    end

    context 'when password is invalid' do
      let(:auth_user) do
        id_double = instance_double(Domain::ValueObject::IdentityId, value: '00000000-0000-0000-0000-000000000001')
        instance_double(
          Domain::Entity::Auth::AuthUserEntity,
          id: id_double,
          user_id: '00000000-0000-0000-0000-000000000001'
        )
      end
      let(:auth_repo) do
        instance_double(Domain::Repository::Auth::AuthRepository, find_by_email: auth_user)
      end
      let(:service_caller) do
        instance_double(Domain::Service::Auth::AuthService, can_login?: false)
      end

      it 'raises AuthenticationFailedException' do
        expect { use_case.invoke(args: input_dto) }
          .to raise_error(Application::Exception::AuthenticationFailedException)
      end
    end
  end
end
