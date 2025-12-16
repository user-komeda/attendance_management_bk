# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Application::UseCase::Auth::SignupUseCase do
  subject(:use_case) { described_class.new }

  let(:input_dto) do
    Application::Dto::Auth::SignupInputDto.new(
      first_name: 'Taro',
      last_name: 'Yamada',
      email: 'taro@example.com',
      password: 'Abcdefg1'
    )
  end

  describe '#invoke' do
    context 'when user does not exist (success path)' do
      let(:service_caller) { instance_double(Domain::Service::Auth::AuthService, exist?: false) }
      let(:user_repo) { instance_double(Domain::Repository::User::UserRepository) }

      let(:persist_return) do
        user_entity = Domain::Entity::User::UserEntity.build_with_id(
          id: '00000000-0000-0000-0000-000000000009',
          first_name: 'Taro',
          last_name: 'Yamada',
          email: 'taro@example.com'
        )

        # Minimal object responding to user_id is enough for build_output_dto
        auth_user_entity = Struct.new(:user_id).new('00000000-0000-0000-0000-000000000009')

        { user_entity: user_entity, auth_user_entity: auth_user_entity }
      end

      before do
        # rubocop:disable RSpec/SubjectStub
        allow(use_case).to receive(:resolve) do |key|
          case key
          when described_class::SERVICE_KEY
            service_caller
          when described_class::USER_REPOSITORY_KEY
            user_repo
          else
            raise "Unexpected key: #{key}"
          end
        end

        # rubocop:enable RSpec/SubjectStub

        # Stub entity builders used inside use case by replacing frozen constants
        user_double = instance_double(Domain::Entity::User::UserEntity)
        auth_user_double = instance_double(Domain::Entity::Auth::AuthUserEntity)

        user_entity_const = class_double(Domain::Entity::User::UserEntity, build: user_double, build_with_auth_user: {})
        auth_user_entity_const = class_double(Domain::Entity::Auth::AuthUserEntity, build: auth_user_double)
        stub_const('Application::UseCase::Auth::SignupUseCase::UserEntity', user_entity_const)
        stub_const('Application::UseCase::Auth::SignupUseCase::AuthUserEntity', auth_user_entity_const)

        allow(user_repo).to receive(:create_with_auth_user).and_return(persist_return)
      end

      it 'returns AuthOutputDto with id and user_id' do
        result = use_case.invoke(input_dto)

        expect(result).to have_attributes(
          id: '00000000-0000-0000-0000-000000000009',
          user_id: '00000000-0000-0000-0000-000000000009'
        )
      end

      it 'persists via user repository' do
        use_case.invoke(input_dto)
        expect(user_repo).to have_received(:create_with_auth_user).once
      end
    end

    context 'when user already exists (duplicate)' do
      let(:service_caller) { instance_double(Domain::Service::Auth::AuthService, exist?: true) }

      before do
        # rubocop:disable RSpec/SubjectStub
        allow(use_case).to receive(:resolve) do |key|
          case key
          when described_class::SERVICE_KEY
            service_caller
          else
            instance_double(Object)
          end
        end
        # rubocop:enable RSpec/SubjectStub
      end

      it 'raises DuplicatedException' do
        expect { use_case.invoke(input_dto) }
          .to raise_error(Application::Exception::DuplicatedException)
      end
    end
  end
end
