# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class GetDetailUserUseCase < Application::UseCase::User::UserBaseUseCase
        # @rbs (args: String) -> ::Application::Dto::User::UserDto
        def invoke(args:)
          caller = resolve(KEY)
          user = caller.get_by_id(id: args)
          raise ::Application::Exception::NotFoundException.new(message: 'user not found') if user.nil?

          USER_DTO.build(user_entity: user)
        end
      end
    end
  end
end
