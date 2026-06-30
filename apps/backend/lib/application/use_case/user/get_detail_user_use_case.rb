# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module User
      class GetDetailUserUseCase < Application::UseCase::User::UserBaseUseCase
        # @rbs (arg: String) -> ::Application::Dto::User::UserDto
        def invoke(arg:)
          caller = resolve(KEY)
          user = caller.get_by_id(id: arg)
          raise ::Application::Exception::NotFoundException.new(message: 'user not found') if user.nil?

          USER_DTO.build(user_entity: user)
        end
      end
    end
  end
end
