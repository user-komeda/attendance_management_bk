# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class CreateUserUseCase < UserBaseUseCase
        # @rbs (::Application::Dto::User::CreateUserInputDto input_dto) -> ::Application::Dto::User::UserDto
        def invoke(input_dto)
          service_caller = resolve(SERVICE_KEY)
          if service_caller.exist?(input_dto.email)
            raise ::Application::Exception::DuplicatedException.new(message: 'User already exists')
          end

          caller = resolve(KEY)
          created_user = caller.create(input_dto.convert_to_entity)
          USER_DTO.build(created_user)
        end
      end
    end
  end
end