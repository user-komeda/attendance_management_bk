# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module Auth
      class SignupUseCase < AuthBaseUseCase
        # @rbs (::Application::Dto::Auth::SignupInputDto input_dto) -> ::Application::Dto::Auth::AuthOutputDto
        def invoke(input_dto)
          check_duplicate!(input_dto)
          entities = build_entities(input_dto)
          result = persist(user_entity: entities[:user_entity], auth_user_entity: entities[:auth_user_entity])
          build_output_dto(result)
        end

        private

        # @rbs (::Application::Dto::Auth::SignupInputDto input_dto) -> untyped
        def check_duplicate!(input_dto)
          service_caller = resolve(SERVICE_KEY)
          return unless service_caller.exist?(input_dto.email)

          raise ::Application::Exception::DuplicatedException.new(message: 'User already exists')
        end

        # rubocop:disable Layout/LineLength
        # @rbs (::Application::Dto::Auth::SignupInputDto input_dto) -> {user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}
        # rubocop:enable Layout/LineLength
        def build_entities(input_dto)
          user_entity = UserEntity.build(
            first_name: input_dto.first_name,
            last_name: input_dto.last_name,
            email: input_dto.email
          )

          auth_user_entity = AuthUserEntity.build(
            {
              password: input_dto.password,
              email: input_dto.email
            }
          )
          { user_entity: user_entity, auth_user_entity: auth_user_entity }
        end

        # rubocop:disable Layout/LineLength
        # @rbs (user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity) -> {user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}
        # rubocop:enable Layout/LineLength
        def persist(user_entity:, auth_user_entity:)
          user_with_auth_user = UserEntity.build_with_auth_user(
            user: user_entity,
            auth_user: auth_user_entity
          )
          user_repository = resolve(USER_REPOSITORY_KEY)
          user_repository.create_with_auth_user(user_with_auth_user)
        end

        # rubocop:disable Layout/LineLength
        # @rbs ({user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}) ->Application::Dto::Auth::AuthOutputDto
        # rubocop:enable Layout/LineLength
        def build_output_dto(result)
          AUTH_OUTPUT_DTO.build(
            id: result[:user_entity].id.value,
            user_id: result[:auth_user_entity].user_id
          )
        end
      end
    end
  end
end
